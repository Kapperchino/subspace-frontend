import 'package:equatable/equatable.dart';

enum CommentingStaus { closed, started, success, failure }

final class CommentingState extends Equatable {
  const CommentingState(
      {this.status = CommentingStaus.closed,
      required this.posterId,
      this.comment = "",
      this.parentId = 1,
      this.isPostComment = true});
  final CommentingStaus status;
  final String comment;
  final int parentId;
  final bool isPostComment;
  final int posterId;

  CommentingState copyWith(
      {CommentingStaus? status, String? comment, int? parentId}) {
    return CommentingState(
        posterId: posterId ?? this.posterId,
        status: status ?? this.status,
        comment: comment ?? this.comment,
        parentId: parentId ?? this.parentId);
  }

  @override
  List<Object> get props =>
      [parentId, comment, isPostComment, status, posterId];
}
