import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/commenting/commentingBloc.dart';
import 'package:frontend/cubit/commenting/commentingEvent.dart';
import 'package:frontend/cubit/commenting/commentingState.dart';

import '../models/comment.dart';
import '../models/post.dart';
import 'commentModal.dart';

class CommentingWidget extends StatelessWidget {
  const CommentingWidget({super.key, this.comment, this.post});

  final Comment? comment;
  final Post? post;
  @override
  Widget build(BuildContext baseContext) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: ElevatedButton(
            onPressed: () {
              if (comment != null) {
                baseContext.read<CommentingBloc>().add(CommentPressed(
                    postId: comment!.postId, parentId: comment!.id));
              }
              if (post != null) {
                baseContext
                    .read<CommentingBloc>()
                    .add(CommentPressed(postId: post!.id));
              }
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: baseContext,
                  builder: (context) {
                    return BlocProvider.value(
                        value: BlocProvider.of<CommentingBloc>(baseContext),
                        child: CommentModal(post: post, comment: comment));
                  });
            },
            child: const Text('Comment'),
          ),
        ));
  }
}
