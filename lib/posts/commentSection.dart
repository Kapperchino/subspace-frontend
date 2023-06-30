import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/posts/comment.dart';

import '../posts/postcard.dart';

class CommentSection extends StatelessWidget {
  const CommentSection({super.key, required this.items});

  final List<CommentWidget> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: items[index]);
      }, childCount: items.length),
    );
  }
}
