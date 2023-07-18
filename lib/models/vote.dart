import 'package:frontend/models/voteRequest.dart';
import 'package:json_annotation/json_annotation.dart';
part 'vote.g.dart';

@JsonSerializable()
class Vote {
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "vote_id")
  final int voteid;
  @JsonKey(name: "post_or_comment_id")
  final int postOrCommentId;
  @JsonKey(name: "is_up_vote")
  final bool isUpvote;
  @JsonKey(name: "vote_type")
  final VoteType voteType;
  @JsonKey(name: "is_deleted")
  final bool isDeleted;

  const Vote(
      {required this.userId,
      required this.postOrCommentId,
      required this.isUpvote,
      required this.voteType,
      required this.voteid,
      required this.isDeleted});

  factory Vote.fromJson(Map<String, dynamic> json) {
    return _$VoteFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VoteToJson(this);
  }
}
