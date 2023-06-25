import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/voteWidget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget(
      {super.key,
      required this.topic,
      this.content = "",
      this.contentType = ContentType.text,
      required this.likes,
      required this.body,
      required this.userName,
      required this.dislikes,
      required this.id});

  final String topic;
  final String body;
  final String userName;
  final String content;
  final int likes;
  final int dislikes;
  final ContentType contentType;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(topic),
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
          Text(body)
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) => Text(topic);

  Widget buildSubtitle(BuildContext context) => Text(content);
}
