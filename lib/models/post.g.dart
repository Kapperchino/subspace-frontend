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
      body: json['body'] as String? ?? "",
      content: json['content'] as String? ?? "",
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['type']) ??
          ContentType.text,
      upVotes: json['up_votes'] as int,
      downVotes: json['down_votes'] as int,
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'space_id': instance.spaceId,
      'poster_id': instance.posterId,
      'topic': instance.topic,
      'body': instance.body,
      'content': instance.content,
      'up_votes': instance.upVotes,
      'down_votes': instance.downVotes,
      'created': instance.created.toIso8601String(),
      'type': _$ContentTypeEnumMap[instance.type]!,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
};
