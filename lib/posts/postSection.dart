import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/voteWidget.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:go_router/go_router.dart';

class PostSection extends StatefulWidget {
  const PostSection(
      {super.key,
      required this.topic,
      this.content = "",
      this.contentType = ContentType.text,
      required this.likes,
      required this.body,
      required this.userName,
      required this.spaceId,
      required this.posterId,
      required this.dislikes,
      required this.parentSpaceId,
      required this.spaceName,
      required this.id,
      required this.created});

  final String topic;
  final String body;
  final String userName;
  final String content;
  final int spaceId;
  final String spaceName;
  final int parentSpaceId;
  final int likes;
  final int dislikes;
  final int posterId;
  final ContentType contentType;
  final int id;
  final DateTime created;

  @override
  State<PostSection> createState() {
    return _PostState(topic, body, userName, content, spaceId, spaceName,
        parentSpaceId, likes, dislikes, posterId, contentType, id, created);
  }
}

class _PostState extends State<PostSection> {
  bool started = false;

  final String topic;
  final String body;
  final String userName;
  final String content;
  final int spaceId;
  final String spaceName;
  final int parentSpaceId;
  final int likes;
  final int dislikes;
  final int posterId;
  final ContentType contentType;
  final int id;
  final DateTime created;

  _PostState(
      this.topic,
      this.body,
      this.userName,
      this.content,
      this.spaceId,
      this.spaceName,
      this.parentSpaceId,
      this.likes,
      this.dislikes,
      this.posterId,
      this.contentType,
      this.id,
      this.created);

  void comment() {
    started = !started;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Card(
          margin: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  topic,
                  style: Theme.of(context).textTheme.titleLarge,
                  textScaleFactor: 1.5,
                ),
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
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text(body)),
              Row(
                children: [
                  VoteWidgetFlat(likes: likes, dislikes: dislikes, postId: id),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            comment();
                          });
                        },
                        child: const Text('Comment'),
                      )),
                ],
              )
            ],
          ),
        )),
        if (started)
          Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Flexible(
                  child: Card(
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      child: const TextField(
                        maxLines: 3,
                        minLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Comment',
                        ),
                      ))))
      ],
    );
  }
}
