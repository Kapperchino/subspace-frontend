import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/comment.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentState.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 900) / 2, 0.0);
    return BlocBuilder<CommentBloc, CommentsState>(builder: (context, state) {
      switch (state.status) {
        case CommentsStatus.failure:
          return const SliverToBoxAdapter(
              child: Center(child: Text('failed to fetch posts')));
        case CommentsStatus.success:
          if (state.comments.isEmpty) {
            return const SliverToBoxAdapter(
                child: Center(child: Text('no posts')));
          }
          return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return CommentWidget(
                      parentId: state.comments[index].comment.parentId,
                      data: state.comments[index]);
                }, childCount: state.comments.length),
              ));
        case CommentsStatus.initial:
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
      }
    });
  }
}
