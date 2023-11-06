import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/commenting/commentingBloc.dart';
import 'package:frontend/cubit/commenting/commentingEvent.dart';

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
          padding: const EdgeInsets.only(right: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 6,
              padding: EdgeInsets.zero,
              minimumSize: const Size(70, 35),
            ),
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
            child: Row(
              children: [
                Icon(
                  Icons.reply_sharp,
                  color: Theme.of(baseContext).colorScheme.secondary,
                  size: 22,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Text(
                    "reply",
                    style: TextStyle(
                        color:
                            Theme.of(baseContext).textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
