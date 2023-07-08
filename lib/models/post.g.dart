// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      spaceId: json['space_id'] as int,
      posterId: json['poster_id'] as int,
      topic: json['topic'] as String,
      posterName: json['poster_name'] as String,
      body: json['body'] as String? ?? "",
      content: json['content'] as String? ?? "",
      spacePicture: json['space_picture'] as String? ?? "",
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
          ContentType.text,
      upVotes: json['up_votes'] as int,
      downVotes: json['down_votes'] as int,
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'space_id': instance.spaceId,
      'space_picture': instance.spacePicture,
      'poster_id': instance.posterId,
      'poster_name': instance.posterName,
      'topic': instance.topic,
      'body': instance.body,
      'content': instance.content,
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
