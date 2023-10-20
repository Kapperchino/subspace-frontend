// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoMeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoMeta _$VideoMetaFromJson(Map<String, dynamic> json) => VideoMeta(
      id: json['id'] as int,
      duration: (json['duration'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      url: json['url'] as String,
      status: json['status'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
    );

Map<String, dynamic> _$VideoMetaToJson(VideoMeta instance) => <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
      'duration': instance.duration,
      'status': instance.status,
      'height': instance.height,
      'width': instance.width,
    };
