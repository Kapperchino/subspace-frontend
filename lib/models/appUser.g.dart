// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as int,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String? ?? "",
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'email': instance.email,
    };
