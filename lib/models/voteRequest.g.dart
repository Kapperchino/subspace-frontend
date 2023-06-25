// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voteRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteRequest _$VoteRequestFromJson(Map<String, dynamic> json) => VoteRequest(
      userId: json['user_id'] as int,
      postOrCommentId: json['post_or_comment_id'] as int,
      isUpvote: json['is_up_vote'] as bool,
      voteType: $enumDecode(_$VoteTypeEnumMap, json['vote_type']),
    );

Map<String, dynamic> _$VoteRequestToJson(VoteRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'post_or_comment_id': instance.postOrCommentId,
      'is_up_vote': instance.isUpvote,
      'vote_type': _$VoteTypeEnumMap[instance.voteType]!,
    };

const _$VoteTypeEnumMap = {
  VoteType.post: 'post',
  VoteType.comment: 'comment',
};
