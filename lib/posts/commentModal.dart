import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:go_router/go_router.dart';

import '../cubit/commenting/commentingBloc.dart';
import '../cubit/commenting/commentingEvent.dart';
import '../cubit/commenting/commentingState.dart';
import '../models/comment.dart';

class CommentModal extends StatelessWidget {
  const CommentModal({super.key, this.comment, this.post});

  final Comment? comment;
  final Post? post;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentingBloc, CommentingState>(
      builder: (context, state) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 132,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (comment != null) {
                        context.read<CommentingBloc>().add(CommentPressed(
                            postId: comment!.postId, parentId: comment!.id));
                      }
                      if (post != null) {
                        context
                            .read<CommentingBloc>()
                            .add(CommentPressed(postId: post!.id));
                      }
                      context.pop();
                    },
                    child: const Text('Comment'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      autofocus: true,
                      maxLines: 3,
                      controller: state.controller,
                      onChanged: (comment) => context
                          .read<CommentingBloc>()
                          .add(CommentChanged(comment: comment)),
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Comment',
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
