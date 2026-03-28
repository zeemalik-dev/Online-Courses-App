// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:academy_app/constants.dart';
import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/providers/auth.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:academy_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';
  const EditProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _isLoading = false;

  final Map<String, dynamic> _userData = {
    'name': '',
    'email': '',
    'biography': '',
    'twitter': '',
    'facebook': '',
    'linkedin': '',
    'photo': '',
  };

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      final currentUser = auth.user;
      
      if (currentUser != null) {
        // Prepare update data
        final updateData = <String, dynamic>{
          'name': _userData['name'] ?? currentUser.name,
          'email': _userData['email'] ?? currentUser.email,
          'biography': _userData['biography'] ?? currentUser.biography,
          'twitter': _userData['twitter'] ?? currentUser.twitter,
          'facebook': _userData['facebook'] ?? currentUser.facebook,
          'linkedin': _userData['linkedin'] ?? currentUser.linkedin,
        };
        
        await auth.updateUserData(updateData);
        CommonFunctions.showSuccessToast('User updated Successfully');
      }
    } on HttpException {
      var errorMsg = 'Update failed';
      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      // print(error);
      const errorMsg = 'Update failed!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: kDefaultInputBorder,
      focusedBorder: kDefaultFocusInputBorder,
      focusedErrorBorder: kDefaultFocusErrorBorder,
      errorBorder: kDefaultFocusErrorBorder,
      filled: true,
      hintStyle: const TextStyle(color: kFormInputColor),
      hintText: hintext,
      fillColor: Colors.white70,
      prefixIcon: Icon(
        iconData,
        color: kFormInputColor,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: FutureBuilder(
        future: Provider.of<Auth>(context, listen: false).getUserInfo(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor.withOpacity(0.7)),
            );
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('Error Occured'),
              );
            } else {
              return Consumer<Auth>(
                builder: (context, authData, child) {
                  final user = authData.user;
                  
                  if (user == null) {
                    return const Center(
                      child: Text('No user data available'),
                    );
                  }
                  
                  // Split name into first and last name for display
                  final nameParts = user.name?.split(' ') ?? ['', ''];
                  final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
                  final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
                  
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 15, top: 10, bottom: 5.0),
                          child: Text(
                            'Update Profile Picture',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: UserImagePicker(
                            image: user.photo,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 0.0, bottom: 5.0),
                                      child: Text(
                                        'First Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, bottom: 8.0),
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: firstName,
                                      decoration: getInputDecoration(
                                          'First Name', Icons.person),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'First name cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        final currentLastName = _userData['last_name'] ?? lastName;
                                        final fullName = '$value $currentLastName'.trim();
                                        _userData['name'] = fullName;
                                        _firstNameController.text = value as String;
                                      },
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'Last Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: lastName,
                                      decoration: getInputDecoration(
                                        'Last Name',
                                        Icons.person,
                                      ),
                                      keyboardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Last name cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        final currentFirstName = _userData['first_name'] ?? firstName;
                                        final fullName = '$currentFirstName $value'.trim();
                                        _userData['name'] = fullName;
                                        _lastNameController.text = value as String;
                                      },
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: TextFormField(
                                      style: const TextStyle(fontSize: 14),
                                      initialValue: user.email,
                                      decoration: getInputDecoration(
                                        'Email',
                                        Icons.email,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      enabled: false, // Email usually can't be changed
                                      onSaved: (value) {
                                        _userData['email'] = value.toString();
                                      },
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'Biography',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 16),
                                    initialValue: user.biography,
                                    decoration: getInputDecoration(
                                      'Biography',
                                      Icons.edit,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    onSaved: (value) {
                                      _userData['biography'] = value.toString();
                                    },
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'Facebook Link',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 16),
                                    initialValue: user.facebook,
                                    decoration: getInputDecoration(
                                      'Facebook Link',
                                      MdiIcons.facebook,
                                    ),
                                    keyboardType: TextInputType.url,
                                    onSaved: (value) {
                                      _userData['facebook'] = value.toString();
                                    },
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'Twitter Link',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 16),
                                    initialValue: user.twitter,
                                    decoration: getInputDecoration(
                                      'Twitter Link',
                                      MdiIcons.twitter,
                                    ),
                                    keyboardType: TextInputType.url,
                                    onSaved: (value) {
                                      _userData['twitter'] = value.toString();
                                    },
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'LinkedIn Link',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 16),
                                    initialValue: user.linkedin,
                                    decoration: getInputDecoration(
                                      'LinkedIn Link',
                                      MdiIcons.linkedin,
                                    ),
                                    keyboardType: TextInputType.url,
                                    onSaved: (value) {
                                      _userData['linkedin'] = value.toString();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _isLoading
                                        ? const Center(child: CircularProgressIndicator())
                                        : MaterialButton(
                                            onPressed: () {
                                              _submit();
                                            },
                                            color: kPrimaryColor,
                                            textColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            splashColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              side: const BorderSide(
                                                  color: kPrimaryColor),
                                            ),
                                            child: const Text(
                                              'Update Now',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
