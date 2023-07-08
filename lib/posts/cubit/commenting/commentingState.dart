import 'package:equatable/equatable.dart';

enum CommentingStaus { closed, started, success, failure }

final class CommentingState extends Equatable {
  const CommentingState(
      {this.status = CommentingStaus.closed,
      this.comment = "",
      this.parentId = 1,
      required this.isPostComment});
  final CommentingStaus status;
  final String comment;
  final int parentId;
  final bool isPostComment;

  CommentingState copyWith(
      {CommentingStaus? status,
      String? comment,
      int? parentId,
      bool? isPostComment}) {
    return CommentingState(
        status: status ?? this.status,
        comment: comment ?? this.comment,
        isPostComment: isPostComment ?? this.isPostComment,
        parentId: parentId ?? this.parentId);
  }

  @override
  List<Object> get props => [parentId, comment, isPostComment, status];
}
