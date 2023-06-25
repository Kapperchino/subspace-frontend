import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.topic,
      this.content = "",
      this.contentType = ContentType.text,
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
  final ContentType contentType;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward_outlined),
                splashRadius: 20,
                color: Colors.blue,
                onPressed: () {},
              ),
              Text((likes + dislikes).toString()),
              IconButton(
                icon: const Icon(Icons.arrow_downward_rounded),
                color: Colors.blue,
                splashRadius: 20,
                onPressed: () {},
              ),
            ],
          )),
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
          Flexible(
              child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(topic),
            subtitle: Text(body),
          )),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context) => Text(topic);

  Widget buildSubtitle(BuildContext context) => Text(content);
}
