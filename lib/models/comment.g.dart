// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as int,
      posterId: json['poster_id'] as int,
      posterName: json['poster_name'] as String,
      body: json['body'] as String,
      content: json['content'] as String? ?? "",
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
          ContentType.text,
      upVotes: json['up_votes'] as int,
      parentId: json['parent_id'] as int,
      downVotes: json['down_votes'] as int,
      created: DateTime.parse(json['created'] as String),
      postId: json['post_id'] as int,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'poster_id': instance.posterId,
      'poster_name': instance.posterName,
      'post_id': instance.postId,
      'body': instance.body,
      'content': instance.content,
      'parent_id': instance.parentId,
      'up_votes': instance.upVotes,
      'down_votes': instance.downVotes,
      'created': instance.created.toIso8601String(),
      'content_type': _$ContentTypeEnumMap[instance.type]!,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
  ContentType.link: 'link',
  ContentType.unknown: 'unknown',
};
