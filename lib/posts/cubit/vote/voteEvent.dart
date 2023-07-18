import 'package:equatable/equatable.dart';
import 'package:frontend/models/voteRequest.dart';
import 'package:frontend/posts/cubit/space/spaceState.dart';
import 'package:frontend/posts/cubit/vote/voteState.dart';

sealed class VoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class InitEvent extends VoteEvent {
  final int id;
  final int likes;
  final int dislikes;
  final VotingStatus status;
  final VoteType type;
  InitEvent(this.id, this.likes, this.dislikes, this.status, this.type);
}

final class UpvoteEvent extends VoteEvent {
  UpvoteEvent();
}

final class DownvoteEvent extends VoteEvent {
  DownvoteEvent();
}
