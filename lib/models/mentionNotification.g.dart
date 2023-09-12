// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentionNotification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MentionNotification _$MentionNotificationFromJson(Map<String, dynamic> json) =>
    MentionNotification(
      fromUserId: json['fromUserId'] as int,
      toUserId: json['toUserId'] as int,
      postId: json['postId'] as int,
      sentDate: DateTime.parse(json['sentDate'] as String),
      title: json['title'] as String,
      body: json['body'] as String,
      key: json['key'] as String,
    );

Map<String, dynamic> _$MentionNotificationToJson(
        MentionNotification instance) =>
    <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'postId': instance.postId,
      'sentDate': instance.sentDate.toIso8601String(),
      'title': instance.title,
      'body': instance.body,
      'key': instance.key,
    };
