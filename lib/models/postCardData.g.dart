// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postCardData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCardData _$PostCardDataFromJson(Map<String, dynamic> json) => PostCardData(
      post: Post.fromJson(json['post'] as Map<String, dynamic>),
      spaceName: json['spaceName'] as String,
      parentSpaceId: json['parentSpaceId'] as int,
    );

Map<String, dynamic> _$PostCardDataToJson(PostCardData instance) =>
    <String, dynamic>{
      'post': instance.post,
      'spaceName': instance.spaceName,
      'parentSpaceId': instance.parentSpaceId,
    };
