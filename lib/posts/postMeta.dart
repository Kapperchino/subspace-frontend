import 'package:flutter/material.dart';
import 'package:frontend/posts/avatarWidget.dart';
import 'package:go_router/go_router.dart';

import '../models/post.dart';

class PostMeta extends StatelessWidget {
  const PostMeta(
      {super.key,
      required this.post,
      required this.spaceName,
      required this.maxUserNameLength});

  final Post post;
  final String spaceName;
  final int maxUserNameLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 5, left: 10, bottom: 5),
          child: AvatarWidget(
            pictureMeta: post.posterPicture,
            post: post,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 5, left: 3),
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(30, 45)),
            child: Text(
              post.posterName.length > maxUserNameLength
                  ? '${post.posterName.substring(0, maxUserNameLength)}...'
                  : post.posterName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              context.push("/u/${post.posterId}");
            },
          ),
        ),
        if (post.spaceName != 'SubSpace' && spaceName != post.spaceName)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5, left: 3),
                child: Text("posted in "),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: AssetImage('assets/default_space_small.png'),
                  backgroundColor: Colors.blue,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(top: 5, left: 5),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: const Size(30, 45)),
                  onPressed: () {
                    context.push("/s/${post.spaceParentId}/${post.spaceName}");
                  },
                  child: Text(
                    's/${post.spaceName}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
