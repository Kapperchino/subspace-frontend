import 'package:equatable/equatable.dart';

import '../space/spaceState.dart';

sealed class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class CommentsFetched extends CommentEvent {
  final int postId;
  CommentsFetched({required this.postId});
}

final class CommentsSortChange extends CommentEvent {
  final SortStatus sortStatus;
  CommentsSortChange({required this.sortStatus});
}
