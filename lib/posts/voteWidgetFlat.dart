import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/vote/voteBloc.dart';
import 'package:frontend/cubit/vote/voteEvent.dart';
import 'package:frontend/cubit/vote/voteState.dart';

class VoteWidgetFlat extends StatelessWidget {
  const VoteWidgetFlat({super.key});

  Color getColorUpVote(VotingStatus status, BuildContext context) {
    if (status == VotingStatus.liked) {
      return Theme.of(context).colorScheme.secondary;
    }
    return Theme.of(context).hintColor;
  }

  Color getColorDownVote(VotingStatus status, BuildContext context) {
    if (status == VotingStatus.disliked) {
      return Theme.of(context).colorScheme.secondary;
    }
    return Theme.of(context).hintColor;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VotingState>(
      builder: (context, state) {
        return ElevatedButton(
            onPressed: () {
              return;
            },
            style: ElevatedButton.styleFrom(
                elevation: 6,
                padding: EdgeInsets.zero,
                minimumSize: const Size(80, 35)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(35, 35)),
                  child: Text(
                    String.fromCharCode(Icons.arrow_upward_rounded.codePoint),
                    style: TextStyle(
                      color: getColorUpVote(state.status, context),
                      inherit: false,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      fontFamily: Icons.space_dashboard_outlined.fontFamily,
                    ),
                  ),
                  onPressed: () {
                    context.read<VoteBloc>().add(UpvoteEvent());
                  },
                ),
                Text(
                  (state.likes - state.dislikes).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(35, 35)),
                  child: Text(
                    String.fromCharCode(Icons.arrow_downward_rounded.codePoint),
                    style: TextStyle(
                      color: getColorDownVote(state.status, context),
                      inherit: false,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      fontFamily: Icons.space_dashboard_outlined.fontFamily,
                    ),
                  ),
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
