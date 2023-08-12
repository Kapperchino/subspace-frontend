// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userMeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) => UserMeta(
      id: json['user_id'] as int,
      displayName: json['display_name'] as String,
      bio: json['bio'] as String? ?? "",
      picture: json['picture_meta'] == null
          ? null
          : PictureMeta.fromJson(json['picture_meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserMetaToJson(UserMeta instance) {
  final val = <String, dynamic>{
    'user_id': instance.id,
    'display_name': instance.displayName,
    'bio': instance.bio,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('picture_meta', instance.picture);
  return val;
}
