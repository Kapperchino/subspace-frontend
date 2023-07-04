import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidget.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatelessWidget {
  const PostCard(
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
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            context.push("/s/$parentSpaceId/$spaceName/p/$id");
          },
          child: Column(children: [
            PostMeta(
                userName: userName,
                posterId: posterId,
                created: created,
                spaceName: spaceName),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                VoteWidget(
                  likes: likes,
                  dislikes: dislikes,
                  postId: id,
                ),
                if (contentType == ContentType.text)
                  const SizedBox(width: 0, height: 0),
                if (contentType == ContentType.picture)
                  FutureBuilder<Image>(
                    future: getImage(content),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: snapshot.data,
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                Expanded(
                    flex: 8,
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(topic),
                      subtitle: Text(body.substring(0, min(500, body.length))),
                      subtitleTextStyle:
                          const TextStyle(overflow: TextOverflow.visible),
                    )),
              ],
            )
          ]),
        ));
  }

  Future<Image> getImage(String link) async {
    final contentType = getUrlType(link);
    if (contentType == ContentType.picture) {
      return Image.network(link);
    }
    Metadata? metadata = await AnyLinkPreview.getMetadata(
      link: link,
      cache: Duration(days: 7),
    );
    return Image.network(metadata!.image!);
  }

  ContentType getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg" || typeString == "png" || typeString == "gif") {
      return ContentType.picture;
    }
    if (typeString == "mp4") {
      return ContentType.video;
    } else {
      return ContentType.unknown;
    }
  }
}
