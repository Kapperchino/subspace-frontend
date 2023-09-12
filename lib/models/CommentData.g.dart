// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
      comment: Comment.fromJson(json['comment'] as Map<String, dynamic>),
      children: (json['children'] as List<dynamic>)
          .map((e) => CommentData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'children': instance.children,
    };
