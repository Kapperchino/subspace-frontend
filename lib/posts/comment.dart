import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/voteRequest.dart';
import 'package:frontend/posts/commentMeta.dart';
import 'package:frontend/cubit/comment/commentBloc.dart';
import 'package:frontend/cubit/comment/commentEvent.dart';
import 'package:frontend/cubit/vote/voteBloc.dart';
import 'package:frontend/cubit/vote/voteEvent.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:frontend/util/votesUtil.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/CommentData.dart';
import 'commentingWidget.dart';
import '../cubit/commenting/commentingBloc.dart';
import 'package:http/http.dart' as http;

import '../cubit/commenting/commentingState.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.parentId, required this.data});

  final int parentId;
  final CommentData data;

  @override
  Widget build(BuildContext context) {
    final comment = data.comment;
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      CommentMeta(comment: data.comment),
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (comment.type == ContentType.text)
            const SizedBox(width: 0, height: 0),
          if (comment.type == ContentType.picture)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: comment.content,
                placeholder: (context, url) => Image.memory(kTransparentImage),
                width: 120,
                memCacheHeight: 120,
                memCacheWidth: 120,
                height: 120,
              ),
            ),
          Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SelectableText(
                  comment.body,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          BlocProvider(
            create: (_) => VoteBloc(
              httpClient: http.Client(),
              type: VoteType.comment,
            )..add(InitEvent(
                data.comment.id,
                data.comment.upVotes,
                data.comment.downVotes,
                VotesUtil.getStatus(data.comment.vote),
                VoteType.comment)),
            child: const VoteWidgetFlat(),
          ),
          CommentingWidget(
            comment: comment,
          )
        ],
      ),
      BlocListener<CommentingBloc, CommentingState>(
        listener: (commentContext, state) {
          ScaffoldMessenger.of(commentContext).clearSnackBars();
          if (state.status == CommentingStaus.success) {
            commentContext
                .read<CommentBloc>()
                .add(CommentsFetched(postId: comment.postId));
            ScaffoldMessenger.of(commentContext).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Comment created')));
          } else if (state.status == CommentingStaus.failure) {
            ScaffoldMessenger.of(commentContext).showSnackBar(const SnackBar(
                backgroundColor: Colors.red, content: Text('Error input')));
          }
        },
        child: const SizedBox(),
      ),
      if (data.children.isNotEmpty)
        Column(
            mainAxisSize: MainAxisSize.min,
            children: data.children
                .map((e) => BlocProvider(
                    create: (_) => CommentingBloc(
                        httpClient: http.Client(),
                        parentId: data.comment.id,
                        isPostComment: false,
                        postId: data.comment.postId),
                    child: Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: CommentWidget(
                        data: e,
                        parentId: data.comment.id,
                      ),
                    ))))
                .toList())
    ]));
  }
}
