// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['user_id'] as int,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      address: json['user_address'] as String,
      bio: json['bio'] as String? ?? "",
      picture: json['picture_meta'] == null
          ? null
          : PictureMeta.fromJson(json['picture_meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) {
  final val = <String, dynamic>{
    'user_id': instance.id,
    'display_name': instance.displayName,
    'bio': instance.bio,
    'email': instance.email,
    'user_address': instance.address,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('picture_meta', instance.picture?.toJson());
  return val;
}
