// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRequest _$PostRequestFromJson(Map<String, dynamic> json) => PostRequest(
      spaceId: json['space_id'] as int,
      posterId: json['poster_id'] as int,
      isUpload: json['is_upload'] as bool? ?? false,
      topic: json['topic'] as String,
      body: json['body'] as String? ?? "",
      content: json['content'] as String? ?? "",
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
          ContentType.text,
    );

Map<String, dynamic> _$PostRequestToJson(PostRequest instance) =>
    <String, dynamic>{
      'space_id': instance.spaceId,
      'poster_id': instance.posterId,
      'topic': instance.topic,
      'body': instance.body,
      'is_upload': instance.isUpload,
      'content': instance.content,
      'content_type': _$ContentTypeEnumMap[instance.type]!,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
  ContentType.link: 'link',
  ContentType.unknown: 'unknown',
};
