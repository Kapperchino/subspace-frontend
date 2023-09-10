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
      postPictures: (json['post_pictures'] as List<dynamic>?)
          ?.map((e) => PictureMeta.fromJson(e as Map<String, dynamic>))
          .toList(),
      spacePicture: json['space_picture'] == null
          ? null
          : PictureMeta.fromJson(json['space_picture'] as Map<String, dynamic>),
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
          ContentType.text,
      link: json['link'] as String?,
      upVotes: json['up_votes'] as int,
      downVotes: json['down_votes'] as int,
      created: DateTime.parse(json['created'] as String),
      spaceParentId: json['space_parent_id'] as int,
      vote: json['vote'] == null
          ? null
          : Vote.fromJson(json['vote'] as Map<String, dynamic>),
      spaceName: json['space_name'] as String,
      posterPicture: json['poster_picture'] == null
          ? null
          : PictureMeta.fromJson(
              json['poster_picture'] as Map<String, dynamic>),
      commentsCount: json['comments_count'] as int,
    );

Map<String, dynamic> _$PostToJson(Post instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'space_id': instance.spaceId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('space_picture', instance.spacePicture);
  val['poster_id'] = instance.posterId;
  val['poster_name'] = instance.posterName;
  writeNotNull('poster_picture', instance.posterPicture);
  val['topic'] = instance.topic;
  val['body'] = instance.body;
  writeNotNull('post_pictures', instance.postPictures);
  val['up_votes'] = instance.upVotes;
  val['down_votes'] = instance.downVotes;
  writeNotNull('link', instance.link);
  val['created'] = instance.created.toIso8601String();
  val['content_type'] = _$ContentTypeEnumMap[instance.type]!;
  writeNotNull('vote', instance.vote);
  val['space_parent_id'] = instance.spaceParentId;
  val['space_name'] = instance.spaceName;
  val['comments_count'] = instance.commentsCount;
  return val;
}

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
  ContentType.link: 'link',
  ContentType.unknown: 'unknown',
};
