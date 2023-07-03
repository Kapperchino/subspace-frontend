
import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';

class PostCardContent extends StatelessWidget {
  const PostCardContent({super.key, required this.postData});

  final Post postData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Expanded(
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  postData.topic,
                ))),
        if (postData.type == ContentType.text)
          const SizedBox(width: 0, height: 0),
        if (postData.type == ContentType.picture)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              postData.content,
              width: 120,
              height: 120,
            ),
          ),
        Expanded(
            child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  postData.body,
                  overflow: TextOverflow.ellipsis,
                ))),
      ],
    ));
  }
}
