import 'dart:ffi';

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.topic,
      required this.content,
      required this.likes,
      required this.body,
      required this.userName,
      required this.dislikes});

  final String topic;
  final String body;
  final String userName;
  final String content;
  final int likes;
  final int dislikes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(topic),
            subtitle: Text(body),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) => Text(topic);

  Widget buildSubtitle(BuildContext context) => Text(content);
}
