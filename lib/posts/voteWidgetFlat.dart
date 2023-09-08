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
        return Flexible(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(35, 45)),
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
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(35, 45)),
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
