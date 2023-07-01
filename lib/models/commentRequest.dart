import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'commentRequest.g.dart';

@JsonSerializable()
class CommentRequest {
  @JsonKey(name: 'poster_id')
  final int posterId;
  @JsonKey(name: 'post_id')
  final int postId;
  final String body;
  final String content;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'content_type')
  final ContentType type;

  const CommentRequest(
      {required this.posterId,
      required this.body,
      this.content = "",
      this.type = ContentType.text,
      this.parentId = 1,
      required this.postId});

  factory CommentRequest.fromJson(Map<String, dynamic> json) {
    return _$CommentRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CommentRequestToJson(this);
  }
}
