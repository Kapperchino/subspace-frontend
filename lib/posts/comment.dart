import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/commentMeta.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/voteWidget.dart';

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
          VoteWidget(
            likes: comment.upVotes,
            dislikes: comment.downVotes,
            postId: comment.postId,
          ),
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
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                subtitle: Text(
                    comment.body.substring(0, min(500, comment.body.length))),
                subtitleTextStyle:
                    const TextStyle(overflow: TextOverflow.visible),
              )),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
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
          if (state.status == CommentingStaus.success) {
            context.read<CommentBloc>().add(
                CommentsFetched(postId: comment.postId));
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
