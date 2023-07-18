import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/appUser.dart';
import 'package:frontend/models/voteRequest.dart';
import 'package:frontend/posts/cubit/vote/voteBloc.dart';
import 'package:frontend/posts/cubit/vote/voteEvent.dart';
import 'package:frontend/posts/cubit/vote/voteState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/stores/store.dart';

import '../config.dart';

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
