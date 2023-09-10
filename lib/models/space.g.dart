// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Space _$SpaceFromJson(Map<String, dynamic> json) => Space(
      id: json['id'] as int,
      parentId: json['parent_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      backgroundPicture: json['background_picture'] == null
          ? null
          : PictureMeta.fromJson(
              json['background_picture'] as Map<String, dynamic>),
      smallPicture: json['small_picture'] == null
          ? null
          : PictureMeta.fromJson(json['small_picture'] as Map<String, dynamic>),
      subCount: json['sub_count'] as int,
    );

Map<String, dynamic> _$SpaceToJson(Space instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'parent_id': instance.parentId,
    'name': instance.name,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('small_picture', instance.smallPicture);
  writeNotNull('background_picture', instance.backgroundPicture);
  val['sub_count'] = instance.subCount;
  return val;
}
