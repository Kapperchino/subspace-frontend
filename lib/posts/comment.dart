import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/voteRequest.dart';
import 'package:frontend/posts/commentMeta.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/vote/voteBloc.dart';
import 'package:frontend/posts/cubit/vote/voteEvent.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:frontend/util/votesUtil.dart';

import '../models/CommentData.dart';
import 'commentingWidget.dart';
import 'cubit/commenting/commentingBloc.dart';
import 'package:http/http.dart' as http;

import 'cubit/commenting/commentingEvent.dart';
import 'cubit/commenting/commentingState.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.parentId, required this.data});

  final int parentId;
  final CommentData data;

  @override
  Widget build(BuildContext context) {
    final comment = data.comment;
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      CommentMeta(
          userName: comment.posterName,
          posterId: comment.posterId,
          created: comment.created),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (comment.type == ContentType.text)
            const SizedBox(width: 0, height: 0),
          if (comment.type == ContentType.picture)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                comment.content,
                width: 120,
                height: 120,
              ),
            ),
          Expanded(
              flex: 9,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    subtitle: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          comment.body
                              .substring(0, min(500, comment.body.length)),
                          textAlign: TextAlign.left,
                        )),
                    subtitleTextStyle:
                        const TextStyle(overflow: TextOverflow.visible),
                  ))),
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
          Flexible(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        context.read<CommentingBloc>().add(CommentPressed(
                            postId: comment.postId, parentId: comment.id));
                      },
                      child: const Text('Comment'),
                    ),
                  )))
        ],
      ),
      const Flexible(child: CommentingWidget()),
      BlocListener<CommentingBloc, CommentingState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state.status == CommentingStaus.success) {
            context
                .read<CommentBloc>()
                .add(CommentsFetched(postId: comment.postId));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Comment created')));
          } else if (state.status == CommentingStaus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
