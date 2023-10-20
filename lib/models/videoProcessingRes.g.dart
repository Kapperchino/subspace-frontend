// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoProcessingRes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoProcessingRes _$VideoProcessingResFromJson(Map<String, dynamic> json) =>
    VideoProcessingRes(
      url: json['url'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: (json['duration'] as num).toDouble(),
    );

Map<String, dynamic> _$VideoProcessingResToJson(VideoProcessingRes instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
    };
