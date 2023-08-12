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
      picture: json['picture'] == null
          ? null
          : PictureMeta.fromJson(json['picture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'displayName': instance.displayName,
    'bio': instance.bio,
    'email': instance.email,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('picture', instance.picture);
  return val;
}
