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
      spaceParentId: json['space_parent_id'] as int,
      vote: json['vote'] == null
          ? null
          : Vote.fromJson(json['vote'] as Map<String, dynamic>),
      spaceName: json['space_name'] as String,
      posterPicture: json['poster_picture'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'space_id': instance.spaceId,
    'space_picture': instance.spacePicture,
    'poster_id': instance.posterId,
    'poster_name': instance.posterName,
    'poster_picture': instance.posterPicture,
    'topic': instance.topic,
    'body': instance.body,
    'content': instance.content,
    'up_votes': instance.upVotes,
    'down_votes': instance.downVotes,
    'created': instance.created.toIso8601String(),
    'content_type': _$ContentTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('vote', instance.vote);
  val['space_parent_id'] = instance.spaceParentId;
  val['space_name'] = instance.spaceName;
  return val;
}

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
  ContentType.link: 'link',
  ContentType.unknown: 'unknown',
};
