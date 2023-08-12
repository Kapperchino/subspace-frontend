import 'package:frontend/cubit/vote/voteState.dart';

import '../models/vote.dart';

class VotesUtil {
  static VotingStatus getStatus(Vote? vote) {
    if (vote == null) {
      return VotingStatus.init;
    }
    var voteStatus = VotingStatus.init;
    if (vote.isDeleted) {
      voteStatus = VotingStatus.init;
    } else {
      if (vote.isUpvote) {
        return VotingStatus.liked;
      } else {
        return VotingStatus.disliked;
      }
    }
    return voteStatus;
  }
}
