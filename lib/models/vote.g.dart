// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      userId: json['user_id'] as int,
      postOrCommentId: json['post_or_comment_id'] as int,
      isUpvote: json['is_up_vote'] as bool,
      voteType: $enumDecode(_$VoteTypeEnumMap, json['vote_type']),
      voteid: json['vote_id'] as int,
      isDeleted: json['is_deleted'] as bool,
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'user_id': instance.userId,
      'vote_id': instance.voteid,
      'post_or_comment_id': instance.postOrCommentId,
      'is_up_vote': instance.isUpvote,
      'vote_type': _$VoteTypeEnumMap[instance.voteType]!,
      'is_deleted': instance.isDeleted,
    };

const _$VoteTypeEnumMap = {
  VoteType.post: 'post',
  VoteType.comment: 'comment',
};
