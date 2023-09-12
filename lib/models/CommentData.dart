import 'package:frontend/models/comment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CommentData.g.dart';

@JsonSerializable(includeIfNull: false)
class CommentData {
  final Comment comment;
  final List<CommentData> children;

  CommentData({required this.comment, required this.children});

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return _$CommentDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CommentDataToJson(this);
  }
}
