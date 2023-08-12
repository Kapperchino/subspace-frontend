import 'package:equatable/equatable.dart';
import 'package:frontend/models/CommentData.dart';

enum CommentsStatus { initial, success, failure }

final class CommentsState extends Equatable {
  const CommentsState(
      {this.status = CommentsStatus.initial,
      this.comments = const <CommentData>[],
      this.hasReachedMax = false});

  final CommentsStatus status;
  final List<CommentData> comments;
  final bool hasReachedMax;

  CommentsState copyWith(
      {CommentsStatus? status,
      List<CommentData>? comments,
      bool? hasReachedMax}) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''CommentsState { status: $status, hasReachedMax: $hasReachedMax, posts: ${comments.length} }''';
  }

  @override
  List<Object> get props => [status, comments, hasReachedMax];
}
