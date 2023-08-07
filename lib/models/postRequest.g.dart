// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostRequest _$PostRequestFromJson(Map<String, dynamic> json) => PostRequest(
      spaceId: json['space_id'] as int,
      posterId: json['poster_id'] as int,
      fileIds:
          (json['file_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      topic: json['topic'] as String?,
      body: json['body'] as String?,
      type: $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
          ContentType.text,
    );

Map<String, dynamic> _$PostRequestToJson(PostRequest instance) {
  final val = <String, dynamic>{
    'space_id': instance.spaceId,
    'poster_id': instance.posterId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('topic', instance.topic);
  writeNotNull('body', instance.body);
  val['content_type'] = _$ContentTypeEnumMap[instance.type]!;
  writeNotNull('file_ids', instance.fileIds);
  return val;
}

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.picture: 'picture',
  ContentType.video: 'video',
  ContentType.link: 'link',
  ContentType.unknown: 'unknown',
};
