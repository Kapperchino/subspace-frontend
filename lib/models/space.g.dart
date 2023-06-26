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
      picture: json['picture'] as String,
    );

Map<String, dynamic> _$SpaceToJson(Space instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'name': instance.name,
      'description': instance.description,
      'picture': instance.picture,
    };
