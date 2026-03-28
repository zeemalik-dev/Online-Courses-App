// user.dart
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? role;
  String? email;
  int? status;

  @JsonKey(name: 'synced_from_dashboard')
  int? syncedFromDashboard;

  @JsonKey(name: 'dashboard_customer_id')
  dynamic dashboardCustomerId;

  @JsonKey(name: 'last_synced_at')
  String? lastSyncedAt;

  String? name;
  String? phone;
  String? country;
  String? gender;

  @JsonKey(name: 'age_range')
  String? ageRange;

  @JsonKey(name: 'years_of_experience')
  String? yearsOfExperience;

  @JsonKey(name: 'customer_id')
  dynamic customerId;

  String? website;
  String? skills;
  String? facebook;
  String? twitter;
  String? linkedin;
  String? address;
  String? about;
  String? biography;
  dynamic educations;
  String? photo;

  @JsonKey(name: 'email_verified_at')
  dynamic emailVerifiedAt;

  dynamic paymentkeys;

  @JsonKey(name: 'video_url')
  dynamic videoUrl;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  String? token;

  User({
    this.id,
    this.role,
    this.email,
    this.status,
    this.syncedFromDashboard,
    this.dashboardCustomerId,
    this.lastSyncedAt,
    this.name,
    this.phone,
    this.country,
    this.gender,
    this.ageRange,
    this.yearsOfExperience,
    this.customerId,
    this.website,
    this.skills,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.address,
    this.about,
    this.biography,
    this.educations,
    this.photo,
    this.emailVerifiedAt,
    this.paymentkeys,
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class LoginResponse {
  String? message;
  User? user;
  String? token;

  LoginResponse({
    this.message,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}