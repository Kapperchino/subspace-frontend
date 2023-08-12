import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CommentingStaus { closed, started, success, failure }

final class CommentingState extends Equatable {
  const CommentingState(
      {this.status = CommentingStaus.closed,
      this.comment = "",
      this.parentId = 1,
      required this.isPostComment,
      required this.controller });
  final CommentingStaus status;
  final String comment;
  final int parentId;
  final bool isPostComment;
  final TextEditingController controller;

  CommentingState copyWith(
      {CommentingStaus? status,
      String? comment,
      int? parentId,
      bool? isPostComment,
      TextEditingController? controller}) {
    return CommentingState(
        status: status ?? this.status,
        comment: comment ?? this.comment,
        isPostComment: isPostComment ?? this.isPostComment,
        parentId: parentId ?? this.parentId,
        controller: controller ?? this.controller);
  }

  @override
  List<Object> get props => [parentId, comment, isPostComment, status];
}
