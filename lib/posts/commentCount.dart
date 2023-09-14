import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:go_router/go_router.dart';

class CommentCount extends StatelessWidget {
  const CommentCount({super.key, required this.count, required this.post});

  final int count;
  final Post post;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          context
              .push("/s/${post.spaceParentId}/${post.spaceName}/p/${post.id}");
        },
        style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: EdgeInsets.zero,
            minimumSize: const Size(65, 35),
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.comment_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 23,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              count.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ],
        ));
  }
}
