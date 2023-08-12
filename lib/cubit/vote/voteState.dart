import 'package:equatable/equatable.dart';

import '../../models/voteRequest.dart';

enum VotingStatus { init, liked, disliked }

final class VotingState extends Equatable {
  const VotingState(
      {this.status = VotingStatus.init,
      this.id = -1,
      this.likes = 0,
      this.dislikes = 0,
      required this.voteType});
  final VotingStatus status;
  final int id;
  final int dislikes;
  final int likes;
  final VoteType voteType;

  VotingState copyWith(
      {VotingStatus? status,
      int? likes,
      int? dislikes,
      int? id,
      VoteType? type}) {
    return VotingState(
        status: status ?? this.status,
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        id: id ?? this.id,
        voteType: type ?? voteType);
  }

  @override
  List<Object> get props => [likes, dislikes, id, status, voteType];
}
