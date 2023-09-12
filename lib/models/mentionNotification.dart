import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'mentionNotification.g.dart';

@JsonSerializable(includeIfNull: false)
class MentionNotification {
  final int fromUserId;
  final int toUserId;
  final int postId;
  final DateTime sentDate;
  final String title;
  final String body;
  final String key;

  const MentionNotification(
      {required this.fromUserId,
      required this.toUserId,
      required this.postId,
      required this.sentDate,
      required this.title,
      required this.body,
      required this.key});

  factory MentionNotification.fromJson(Map<String, dynamic> json) {
    return _$MentionNotificationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$MentionNotificationToJson(this);
  }
}
