import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/post.dart';
import 'package:frontend/posts/voteWidget.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(
      {super.key,
      this.content = "",
      this.contentType = ContentType.text,
      required this.likes,
      required this.body,
      required this.userName,
      required this.posterId,
      required this.dislikes,
      required this.postId,
      required this.id,
      required this.created});

  final String body;
  final String userName;
  final String content;
  final int likes;
  final int postId;
  final int dislikes;
  final int posterId;
  final ContentType contentType;
  final int id;
  final DateTime created;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          VoteWidget(
            likes: likes,
            dislikes: dislikes,
            postId: id,
          ),
          if (contentType == ContentType.text)
            const SizedBox(width: 0, height: 0),
          if (contentType == ContentType.picture)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                content,
                width: 120,
                height: 120,
              ),
            ),
          Expanded(
              flex: 8,
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                subtitle: Text(body.substring(0, min(500, body.length))),
                subtitleTextStyle:
                    const TextStyle(overflow: TextOverflow.visible),
              )),
        ],
      ),
    );
  }
}
