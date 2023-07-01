// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentRequest _$CommentRequestFromJson(Map<String, dynamic> json) =>
    CommentRequest(
      posterId: json['poster_id'] as int,
      body: json['body'] as String,
      content: json['content'] as String? ?? "",
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
          ContentType.text,
      parentId: json['parent_id'] as int,
      postId: json['post_id'] as int,
    );

Map<String, dynamic> _$CommentRequestToJson(CommentRequest instance) =>
    <String, dynamic>{
      'poster_id': instance.posterId,
      'post_id': instance.postId,
      'body': instance.body,
      'content': instance.content,
      'parent_id': instance.parentId,
      'content_type': _$ContentTypeEnumMap[instance.type]!,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
};
