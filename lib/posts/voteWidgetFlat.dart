
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/vote/voteBloc.dart';
import 'package:frontend/cubit/vote/voteEvent.dart';
import 'package:frontend/cubit/vote/voteState.dart';


class VoteWidgetFlat extends StatelessWidget {
  const VoteWidgetFlat({super.key});

  MaterialColor getColorUpVote(VotingStatus status) {
    if (status == VotingStatus.liked) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  MaterialColor getColorDownVote(VotingStatus status) {
    if (status == VotingStatus.disliked) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VotingState>(
      builder: (context, state) {
        return Flexible(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward_rounded),
              splashRadius: 20,
              color: getColorUpVote(state.status),
              onPressed: () {
                context.read<VoteBloc>().add(UpvoteEvent());
              },
            ),
            Text((state.likes - state.dislikes).toString()),
            IconButton(
              icon: const Icon(Icons.arrow_downward_rounded),
              color: getColorDownVote(state.status),
              splashRadius: 20,
              onPressed: () {
                context.read<VoteBloc>().add(DownvoteEvent());
              },
            ),
          ],
        ));
      },
    );
  }
}
