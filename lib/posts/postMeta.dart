import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:go_router/go_router.dart';

import '../models/post.dart';

class PostMeta extends StatelessWidget {
  const PostMeta(
      {super.key, required this.post, required this.maxUserNameLength});

  final Post post;
  final int maxUserNameLength;

  @override
  Widget build(BuildContext context) {
    final defaultProfileIndex = post.posterId % 6;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
          child: CircleAvatar(
            maxRadius: 20,
            foregroundImage: NetworkImage(post.posterPicture),
            backgroundImage:
                AssetImage('assets/default_profile_$defaultProfileIndex.png'),
            backgroundColor: Colors.blue,
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
            ),
            onPressed: () {},
          ),
        ),
        if (post.spaceName != 'SubSpace')
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
                  child: Text('s/${post.spaceName}'),
                ),
              ),
            ],
          ),
        const Spacer(),
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 10),
              child: Text("${getTime(post.created)} ago"),
            ))
      ],
    );
  }

  String getTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays >= 365) {
      final years = diff.inDays / 365;
      if (years == 1) {
        return '$years year';
      }
      return '$years years';
    }
    if (diff.inDays >= 1) {
      final days = diff.inDays;
      if (days == 1) {
        return '$days day';
      }
      return '$days days';
    }
    if (diff.inHours >= 1) {
      final hours = diff.inHours;
      if (hours == 1) {
        return '$hours hour';
      }
      return '$hours hours';
    }

    if (diff.inMinutes >= 1) {
      final minutes = diff.inMinutes;
      if (minutes == 1) {
        return '$minutes minute';
      }
      return '$minutes minutes';
    }

    final seconds = diff.inSeconds;
    return '$seconds seconds';
  }
}
