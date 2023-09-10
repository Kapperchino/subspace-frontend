import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/comment.dart';
import 'package:go_router/go_router.dart';

import '../models/pictureMeta.dart';

class CommentMeta extends StatelessWidget {
  const CommentMeta({super.key, required this.comment});

  final Comment comment;

  @override
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
          child: InkWell(
              onTap: () {
                context.push("/u/${comment.posterId}");
              },
              child: CircleAvatar(
                maxRadius: 20,
                backgroundImage: getProfilePic(comment.posterPicture),
                backgroundColor: Colors.blue,
              )),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(top: 5, left: 3),
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(35, 45)),
            child: Text(
              comment.posterName,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              context.push("/u/${comment.posterId}");
            },
          ),
        ),
        const Spacer(),
        Flexible(
            child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Text("${getTime(comment.created)} ago"),
                ))),
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

  ImageProvider getProfilePic(PictureMeta? picture) {
    final defaultProfileIndex = comment.posterId % 6;
    if (picture == null) {
      return AssetImage('assets/default_profile_$defaultProfileIndex.png');
    }
    return CachedNetworkImageProvider(picture.url);
  }
}
