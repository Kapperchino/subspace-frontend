import 'package:flutter/material.dart';
import 'package:frontend/models/pictureMeta.dart';
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
          child: CircleAvatar(
            maxRadius: 20,
            foregroundImage: getProfilePic(post.posterPicture),
            backgroundColor: Colors.blue,
            child: InkWell(
              onTap: () {
                context.push("/u/${post.posterId}");
              },
            ),
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
                  child: Text('s/${post.spaceName}'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  ImageProvider getProfilePic(PictureMeta? picture) {
    final defaultProfileIndex = post.posterId % 6;
    if (picture == null) {
      return AssetImage('assets/default_profile_$defaultProfileIndex.png');
    }
    return NetworkImage(picture.url);
  }
}
