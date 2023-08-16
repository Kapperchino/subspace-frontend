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
      posterPicture: json['poster_picture'] == null
          ? null
          : PictureMeta.fromJson(
              json['poster_picture'] as Map<String, dynamic>),
      upVotes: json['up_votes'] as int,
      parentId: json['parent_id'] as int,
      downVotes: json['down_votes'] as int,
      created: DateTime.parse(json['created'] as String),
      postId: json['post_id'] as int,
      vote: json['vote'] == null
          ? null
          : Vote.fromJson(json['vote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'poster_id': instance.posterId,
    'poster_name': instance.posterName,
    'post_id': instance.postId,
    'body': instance.body,
    'content': instance.content,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('poster_picture', instance.posterPicture);
  val['parent_id'] = instance.parentId;
  val['up_votes'] = instance.upVotes;
  val['down_votes'] = instance.downVotes;
  val['created'] = instance.created.toIso8601String();
  val['content_type'] = _$ContentTypeEnumMap[instance.type]!;
  writeNotNull('vote', instance.vote);
  return val;
}

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
  ContentType.link: 'link',
  ContentType.unknown: 'unknown',
};
