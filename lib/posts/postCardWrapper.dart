import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/vote/voteBloc.dart';
import 'package:frontend/posts/postcard.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/voteRequest.dart';
import '../util/votesUtil.dart';
import '../cubit/vote/voteEvent.dart';

class PostCardWrapper extends StatelessWidget {
  const PostCardWrapper(
      {super.key, required this.post, required this.spaceName});

  final Post post;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoteBloc(
        httpClient: http.Client(),
        type: VoteType.post,
      )..add(InitEvent(post.id, post.upVotes, post.downVotes,
          VotesUtil.getStatus(post.vote), VoteType.post)),
      child: PostCard(
        post: post,
        spaceName: spaceName,
      ),
    );
  }
}
