// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentsState _$CommentsStateFromJson(Map<String, dynamic> json) =>
    CommentsState(
      status: $enumDecodeNullable(_$CommentsStatusEnumMap, json['status']) ??
          CommentsStatus.initial,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => CommentData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CommentData>[],
      hasReachedMax: json['hasReachedMax'] as bool? ?? false,
      sortStatus:
          $enumDecodeNullable(_$SortStatusEnumMap, json['sortStatus']) ??
              SortStatus.latest,
      postId: json['postId'] as int? ?? -1,
    );

Map<String, dynamic> _$CommentsStateToJson(CommentsState instance) =>
    <String, dynamic>{
      'status': _$CommentsStatusEnumMap[instance.status]!,
      'sortStatus': _$SortStatusEnumMap[instance.sortStatus]!,
      'comments': instance.comments,
      'hasReachedMax': instance.hasReachedMax,
      'postId': instance.postId,
    };

const _$CommentsStatusEnumMap = {
  CommentsStatus.initial: 'initial',
  CommentsStatus.success: 'success',
  CommentsStatus.failure: 'failure',
};

const _$SortStatusEnumMap = {
  SortStatus.latest: 'latest',
  SortStatus.popular: 'popular',
};
