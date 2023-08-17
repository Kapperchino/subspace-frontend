import 'package:equatable/equatable.dart';
import 'package:frontend/models/CommentData.dart';

import '../space/spaceState.dart';

enum CommentsStatus { initial, success, failure }

final class CommentsState extends Equatable {
  const CommentsState(
      {this.status = CommentsStatus.initial,
      this.comments = const <CommentData>[],
      this.hasReachedMax = false,
      this.sortStatus = SortStatus.latest,
      this.postId = -1});

  final CommentsStatus status;
  final SortStatus sortStatus;
  final List<CommentData> comments;
  final bool hasReachedMax;
  final int postId;

  CommentsState copyWith(
      {CommentsStatus? status,
      List<CommentData>? comments,
      bool? hasReachedMax,
      SortStatus? sortStatus,
      int? postId}) {
    return CommentsState(
        status: status ?? this.status,
        comments: comments ?? this.comments,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        sortStatus: sortStatus ?? this.sortStatus,
        postId: postId ?? this.postId);
  }

  @override
  String toString() {
    return '''CommentsState { status: $status, hasReachedMax: $hasReachedMax, posts: ${comments.length} }''';
  }

  @override
  List<Object> get props =>
      [status, comments, hasReachedMax, postId, sortStatus];
}
