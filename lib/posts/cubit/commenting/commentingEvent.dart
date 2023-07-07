import 'package:equatable/equatable.dart';

sealed class CommentingEvent extends Equatable {
  const CommentingEvent();

  @override
  List<Object> get props => [];
}

final class CommentPressed extends CommentingEvent {
  final String comment;
  final int postId;
  final int parentId;
  const CommentPressed(
      {required this.comment, required this.postId, this.parentId = 1});
}
