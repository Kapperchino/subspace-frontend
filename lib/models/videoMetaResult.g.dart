// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoMetaResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoMetaResult _$VideoMetaResultFromJson(Map<String, dynamic> json) =>
    VideoMetaResult(
      id: json['id'] as int,
      presigned: json['presigned'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$VideoMetaResultToJson(VideoMetaResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'presigned': instance.presigned,
      'url': instance.url,
    };
