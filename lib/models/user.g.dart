// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int?,
    role: json['role'] as String?,
    email: json['email'] as String?,
    status: json['status'] as int?,
    syncedFromDashboard: json['synced_from_dashboard'] as int?,
    dashboardCustomerId: json['dashboard_customer_id'],
    lastSyncedAt: json['last_synced_at'] as String?,
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    country: json['country'] as String?,
    gender: json['gender'] as String?,
    ageRange: json['age_range'] as String?,
    yearsOfExperience: json['years_of_experience'] as String?,
    customerId: json['customer_id'],
    website: json['website'] as String?,
    skills: json['skills'] as String?,
    facebook: json['facebook'] as String?,
    twitter: json['twitter'] as String?,
    linkedin: json['linkedin'] as String?,
    address: json['address'] as String?,
    about: json['about'] as String?,
    biography: json['biography'] as String?,
    educations: json['educations'],
    photo: json['photo'] as String?,
    emailVerifiedAt: json['email_verified_at'],
    paymentkeys: json['paymentkeys'],
    videoUrl: json['video_url'],
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'email': instance.email,
      'status': instance.status,
      'synced_from_dashboard': instance.syncedFromDashboard,
      'dashboard_customer_id': instance.dashboardCustomerId,
      'last_synced_at': instance.lastSyncedAt,
      'name': instance.name,
      'phone': instance.phone,
      'country': instance.country,
      'gender': instance.gender,
      'age_range': instance.ageRange,
      'years_of_experience': instance.yearsOfExperience,
      'customer_id': instance.customerId,
      'website': instance.website,
      'skills': instance.skills,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'address': instance.address,
      'about': instance.about,
      'biography': instance.biography,
      'educations': instance.educations,
      'photo': instance.photo,
      'email_verified_at': instance.emailVerifiedAt,
      'paymentkeys': instance.paymentkeys,
      'video_url': instance.videoUrl,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'token': instance.token,
    };

// LoginResponse serialization
LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    message: json['message'] as String?,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    token: json['token'] as String?,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
      'token': instance.token,
    };