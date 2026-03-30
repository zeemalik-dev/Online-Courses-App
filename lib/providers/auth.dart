import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:wilan/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'shared_pref_helper.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  User? _user;

  String? get token {
    return _token;
  }

  String? get userId {
    return _userId;
  }

  User? get user {
    return _user;
  }

  Future<void> login(String email, String password) async {
    var url = '$BASE_URL/api/login?email=$email&password=$password';

    try {
      final response = await http.post(Uri.parse(url));
      final responseData = json.decode(response.body);
      log(responseData.toString());
// debugger();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the login response using LoginResponse model
        final loginResponse = LoginResponse.fromJson(responseData);

        if (loginResponse.user != null && loginResponse.token != null) {
          _user = loginResponse.user;
          _token = loginResponse.token;
          _userId = loginResponse.user?.id?.toString();

          // Save to shared preferences
          await SharedPreferenceHelper().setAuthToken(_token!);
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode({
            'token': _token,
            'user_id': _userId,
            'user': _user?.toJson(),
          });
          prefs.setString('userData', userData);
        } else {
          // Handle case where login response doesn't have user data
          throw const HttpException('Invalid login response');
        }
      } else {
        throw const HttpException('Login failed');
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getUserInfo() async {
    final authToken = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/userdata?auth_token=$authToken';

    try {
      if (authToken == null) {
        throw const HttpException('No Auth User');
      }

      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      // Update existing user with new data
      if (_user != null) {
        _user = User(
          id: _user!.id,
          role: _user!.role,
          email: responseData['email'] ?? _user!.email,
          status: _user!.status,
          syncedFromDashboard: _user!.syncedFromDashboard,
          dashboardCustomerId: _user!.dashboardCustomerId,
          lastSyncedAt: _user!.lastSyncedAt,
          name: '${responseData['first_name']} ${responseData['last_name']}',
          phone: _user!.phone,
          country: _user!.country,
          gender: _user!.gender,
          ageRange: _user!.ageRange,
          yearsOfExperience: _user!.yearsOfExperience,
          customerId: _user!.customerId,
          website: _user!.website,
          skills: _user!.skills,
          facebook: responseData['facebook'] ?? _user!.facebook,
          twitter: responseData['twitter'] ?? _user!.twitter,
          linkedin: responseData['linkedin'] ?? _user!.linkedin,
          address: _user!.address,
          about: _user!.about,
          biography: responseData['biography'] ?? _user!.biography,
          educations: _user!.educations,
          photo: responseData['image'] ?? _user!.photo,
          emailVerifiedAt: _user!.emailVerifiedAt,
          paymentkeys: _user!.paymentkeys,
          videoUrl: _user!.videoUrl,
          createdAt: _user!.createdAt,
          updatedAt: _user!.updatedAt,
          token: _user!.token,
        );
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> userImageUpload(File image) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    var url = '$BASE_URL/api/upload_user_image';
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    request.fields['auth_token'] = token!;

    request.files.add(http.MultipartFile(
        'file', image.readAsBytes().asStream(), image.lengthSync(),
        filename: basename(image.path)));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        response.stream.transform(utf8.decoder).listen((value) {
          final responseData = json.decode(value);
          if (responseData['status'] != 'success') {
            throw const HttpException('Upload Failed');
          }
          // Update user photo after successful upload
          if (_user != null && responseData['image'] != null) {
            _user = User(
              id: _user!.id,
              role: _user!.role,
              email: _user!.email,
              status: _user!.status,
              syncedFromDashboard: _user!.syncedFromDashboard,
              dashboardCustomerId: _user!.dashboardCustomerId,
              lastSyncedAt: _user!.lastSyncedAt,
              name: _user!.name,
              phone: _user!.phone,
              country: _user!.country,
              gender: _user!.gender,
              ageRange: _user!.ageRange,
              yearsOfExperience: _user!.yearsOfExperience,
              customerId: _user!.customerId,
              website: _user!.website,
              skills: _user!.skills,
              facebook: _user!.facebook,
              twitter: _user!.twitter,
              linkedin: _user!.linkedin,
              address: _user!.address,
              about: _user!.about,
              biography: _user!.biography,
              educations: _user!.educations,
              photo: responseData['image'],
              emailVerifiedAt: _user!.emailVerifiedAt,
              paymentkeys: _user!.paymentkeys,
              videoUrl: _user!.videoUrl,
              createdAt: _user!.createdAt,
              updatedAt: _user!.updatedAt,
              token: _user!.token,
            );
            notifyListeners();
          }
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _user = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    const url = '$BASE_URL/api/update_userdata';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'auth_token': token,
          ...userData, // Spread the user data map
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw const HttpException('Update Failed');
      }

      // Update user with new data
      if (_user != null && responseData['user'] != null) {
        _user = User.fromJson(responseData['user']);
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateUserPassword(
      String currentPassword, String newPassword) async {
    final token = await SharedPreferenceHelper().getAuthToken();
    const url = '$BASE_URL/api/update_password';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'auth_token': token,
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': newPassword,
        },
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'failed') {
        throw const HttpException('Password update Failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Helper method to load user from shared preferences
  Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final userData = json.decode(userDataString);
      _token = userData['token'];
      _userId = userData['user_id'];

      if (userData['user'] != null) {
        _user = User.fromJson(userData['user']);
        notifyListeners();
      }
    }
  }
}
