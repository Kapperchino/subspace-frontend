import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:go_router/go_router.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget(
      {super.key, required this.pictureMeta, required this.post});

  final PictureMeta? pictureMeta;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 20,
      backgroundImage: getProfilePic(pictureMeta),
      child: InkWell(
        onTap: () {
          context.push("/u/${post.posterId}");
        },
      ),
    );
  }

  ImageProvider getProfilePic(PictureMeta? picture) {
    final defaultProfileIndex = post.posterId % 6;
    if (picture == null) {
      return AssetImage('assets/default_profile_$defaultProfileIndex.png');
    }
    return CachedNetworkImageProvider(picture.url,maxHeight: 120,maxWidth: 120);
  }
}
