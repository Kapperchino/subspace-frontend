// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appUserRes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserRes _$AppUserResFromJson(Map<String, dynamic> json) => AppUserRes(
      id: json['user_id'] as int,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      bio: json['bio'] as String? ?? "",
    );

Map<String, dynamic> _$AppUserResToJson(AppUserRes instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'display_name': instance.displayName,
      'bio': instance.bio,
      'email': instance.email,
      'token': instance.token,
    };
