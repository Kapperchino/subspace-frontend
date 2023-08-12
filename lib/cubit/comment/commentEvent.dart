import 'package:equatable/equatable.dart';

sealed class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class CommentsFetched extends CommentEvent {
  final int postId;
  CommentsFetched({required this.postId});
}
