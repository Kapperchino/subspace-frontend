import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/userMeta.dart';
import 'package:go_router/go_router.dart';

class UserResult extends StatelessWidget {
  const UserResult({
    super.key,
    required this.user,
  });

  final UserMeta user;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            context.push("/u/${user.id}");
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                child: CircleAvatar(
                  maxRadius: 20,
                  foregroundImage: getProfilePic(user.picture),
                  backgroundColor: Colors.blue,
                  child: InkWell(
                    onTap: () {
                      context.push("/u/${user.id}");
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
                    user.displayName.length > 20
                        ? '${user.displayName.substring(0, 20)}...'
                        : user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    context.push("/u/${user.id}");
                  },
                ),
              ),
            ],
          ),
        ));
  }

  ImageProvider getProfilePic(PictureMeta? picture) {
    final defaultProfileIndex = user.id % 6;
    if (picture == null) {
      return AssetImage('assets/default_profile_$defaultProfileIndex.png');
    }
    return CachedNetworkImageProvider(picture.url);
  }
}
