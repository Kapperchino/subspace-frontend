// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votesMeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VotesMeta _$VotesMetaFromJson(Map<String, dynamic> json) => VotesMeta(
      userId: json['user_id'] as int,
      postOrCommentId: json['post_or_comment_id'] as int,
      isUpvote: json['is_up_vote'] as bool,
      voteType: $enumDecode(_$VoteTypeEnumMap, json['vote_type']),
      voteid: json['vote_id'] as int,
      upVotes: json['up_votes'] as int,
      downVotes: json['down_votes'] as int,
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$VotesMetaToJson(VotesMeta instance) => <String, dynamic>{
      'user_id': instance.userId,
      'vote_id': instance.voteid,
      'post_or_comment_id': instance.postOrCommentId,
      'is_up_vote': instance.isUpvote,
      'is_deleted': instance.isDeleted,
      'vote_type': _$VoteTypeEnumMap[instance.voteType]!,
      'up_votes': instance.upVotes,
      'down_votes': instance.downVotes,
    };

const _$VoteTypeEnumMap = {
  VoteType.post: 'post',
  VoteType.comment: 'comment',
};
