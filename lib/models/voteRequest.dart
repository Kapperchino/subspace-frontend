import 'package:json_annotation/json_annotation.dart';
part 'voteRequest.g.dart';

enum VoteType {
  @JsonValue("post")
  post,
  @JsonValue("comment")
  comment
}

@JsonSerializable(explicitToJson: true)
class VoteRequest {
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "post_or_comment_id")
  final int postOrCommentId;
  @JsonKey(name: "is_up_vote")
  final bool isUpvote;
  @JsonKey(name: "vote_type")
  final VoteType voteType;

  const VoteRequest(
      {required this.userId,
      required this.postOrCommentId,
      required this.isUpvote,
      required this.voteType});

  factory VoteRequest.fromJson(Map<String, dynamic> json) {
    return _$VoteRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VoteRequestToJson(this);
  }
}
