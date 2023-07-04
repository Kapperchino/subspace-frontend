import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/posts/comment.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.items});

  final List<CommentWidget> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 900) / 2, 0.0);
    return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        sliver: SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return items[index];
          }, childCount: items.length),
        ));
  }
}
