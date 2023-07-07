import 'package:equatable/equatable.dart';

sealed class CommentingEvent extends Equatable {
  const CommentingEvent();

  @override
  List<Object> get props => [];
}

final class CommentPressed extends CommentingEvent {
  final int postId;
  final int parentId;
  const CommentPressed({required this.postId, this.parentId = 1});
}

final class CommentChanged extends CommentingEvent {
  final String comment;
  const CommentChanged({required this.comment});
}
