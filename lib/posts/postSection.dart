import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/commentingWidget.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/commenting/commentingBloc.dart';
import 'package:frontend/posts/cubit/commenting/commentingState.dart';
import 'package:frontend/posts/cubit/post/postBloc.dart';
import 'package:frontend/posts/cubit/post/postState.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';

import 'cubit/commenting/commentingEvent.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key, required this.id, required this.spaceName});
  final int id;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state.status == PostStatus.success) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Card(
              margin: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      state.post!.topic,
                      style: Theme.of(context).textTheme.titleLarge,
                      textScaleFactor: 1.5,
                    ),
                  )),
                  if (state.post!.type == ContentType.text)
                    const SizedBox(width: 0, height: 0),
                  if (state.post!.type == ContentType.picture)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        state.post!.content,
                        width: 600,
                        height: 600,
                        fit: BoxFit.fill,
                      ),
                    ),
                  Flexible(
                      child:Align(alignment: Alignment.topLeft,child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Text(state.post!.body,textAlign: TextAlign.left,)))),
                  Flexible(
                      child: PostMeta(
                          userName: state.post!.posterName,
                          posterId: state.post!.posterId,
                          created: state.post!.created,
                          spaceName: spaceName)),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      VoteWidgetFlat(
                          likes: state.post!.upVotes,
                          dislikes: state.post!.downVotes,
                          postId: id),
                      Flexible(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      context.read<CommentingBloc>().add(
                                          CommentPressed(
                                              postId: id));
                                    },
                                    child: const Text('Comment'),
                                  )))),
                    ],
                  ),
                ],
              ),
            )),
            const Flexible(child: CommentingWidget()),
            BlocListener<CommentingBloc, CommentingState>(
              listener: (context, state) {
                if (state.status == CommentingStaus.success) {
                  BlocProvider.of<CommentBloc>(context)
                      .add(CommentsFetched(postId: id));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Comment created')));
                } else if (state.status == CommentingStaus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Error input')));
                }
              },
              child: const SizedBox(),
            )
          ],
        );
      }
      return const CircularProgressIndicator.adaptive();
    });
  }
}
