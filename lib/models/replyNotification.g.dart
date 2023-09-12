// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replyNotification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyNotification _$ReplyNotificationFromJson(Map<String, dynamic> json) =>
    ReplyNotification(
      spaceId: json['spaceId'] as int,
      commentId: json['commentId'] as int,
      postId: json['postId'] as int,
      sentDate: DateTime.parse(json['sentDate'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      key: json['key'] as String,
    );

Map<String, dynamic> _$ReplyNotificationToJson(ReplyNotification instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'commentId': instance.commentId,
      'spaceId': instance.spaceId,
      'sentDate': instance.sentDate.toIso8601String(),
      'title': instance.title,
      'body': instance.body,
      'key': instance.key,
    };
