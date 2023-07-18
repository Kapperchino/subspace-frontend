import 'package:frontend/models/voteRequest.dart';
import 'package:json_annotation/json_annotation.dart';
part 'votesMeta.g.dart';

@JsonSerializable()
class VotesMeta {
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "vote_id")
  final int voteid;
  @JsonKey(name: "post_or_comment_id")
  final int postOrCommentId;
  @JsonKey(name: "is_up_vote")
  final bool isUpvote;
  @JsonKey(name: "is_deleted")
  final bool isDeleted;
  @JsonKey(name: "vote_type")
  final VoteType voteType;
  @JsonKey(name: "up_votes")
  final int upVotes;
  @JsonKey(name: "down_votes")
  final int downVotes;

  const VotesMeta(
      {required this.userId,
      required this.postOrCommentId,
      required this.isUpvote,
      required this.voteType,
      required this.voteid,
      required this.upVotes,
      required this.downVotes,
      required this.isDeleted,});

  factory VotesMeta.fromJson(Map<String, dynamic> json) {
    return _$VotesMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VotesMetaToJson(this);
  }
}
