import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'replyNotification.g.dart';

@JsonSerializable(includeIfNull: false)
class ReplyNotification {
  final int postId;
  final int commentId;
  final int spaceId;
  final DateTime sentDate;
  final String title;
  final String body;
  final String key;

  const ReplyNotification(
      {required this.spaceId,
      required this.commentId,
      required this.postId,
      required this.sentDate,
      required this.title,
      required this.body,
      required this.key});

  factory ReplyNotification.fromJson(Map<String, dynamic> json) {
    return _$ReplyNotificationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ReplyNotificationToJson(this);
  }
}
