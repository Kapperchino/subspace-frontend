// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pictureMetaResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureMetaResult _$PictureMetaResultFromJson(Map<String, dynamic> json) =>
    PictureMetaResult(
      width: json['width'] as int,
      height: json['height'] as int,
      id: json['id'] as int,
      presigned: json['presigned'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$PictureMetaResultToJson(PictureMetaResult instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'id': instance.id,
      'presigned': instance.presigned,
      'url': instance.url,
    };
