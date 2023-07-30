import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/vote/voteBloc.dart';
import 'package:frontend/posts/postcard.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:http/http.dart' as http;

import '../models/postCardData.dart';
import '../models/voteRequest.dart';
import '../util/votesUtil.dart';
import 'cubit/vote/voteEvent.dart';

class PostCardWrapper extends StatelessWidget {
  const PostCardWrapper({
    super.key,
    required this.data,
  });

  final PostCardData data;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoteBloc(
        httpClient: http.Client(),
        type: VoteType.post,
      )..add(InitEvent(data.post.id, data.post.upVotes, data.post.downVotes,
          VotesUtil.getStatus(data.post.vote), VoteType.post)),
      child: PostCard(
        data: data,
      ),
    );
  }
}
