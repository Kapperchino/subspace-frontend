import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidget.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/postCardData.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.data,
  });

  final PostCardData data;

  @override
  Widget build(BuildContext context) {
    final post = data.post;
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            context.push(
                "/s/${data.parentSpaceId}/${data.spaceName}/p/${post.id}");
          },
          child: Column(children: [
            PostMeta(
                userName: post.posterName,
                posterId: post.posterId,
                created: post.created,
                spaceName: data.spaceName),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                VoteWidget(
                  likes: post.upVotes,
                  dislikes: post.downVotes,
                  postId: post.id,
                ),
                if (post.type == ContentType.text)
                  const SizedBox(width: 0, height: 0),
                if (post.type == ContentType.picture ||
                    post.type == ContentType.link)
                  FutureBuilder<Image>(
                    future: getImage(post.content),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                            child: InkWell(
                          onTap: () async {
                            if (post.type == ContentType.link) {
                              final Uri url = Uri.parse(post.content);
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            }
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: snapshot.data,
                              )),
                        ));
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                Expanded(
                    flex: 8,
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        post.topic,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      subtitle: Text(post.body, maxLines: 4),
                      subtitleTextStyle:
                          const TextStyle(overflow: TextOverflow.fade),
                    )),
              ],
            )
          ]),
        ));
  }

  Future<Image> getImage(String link) async {
    final contentType = getUrlType(link);
    if (contentType == ContentType.picture) {
      return Image.network(
        link,
        width: 100,
        height: 100,
        fit: BoxFit.fill,
      );
    }
    Metadata? metadata = await AnyLinkPreview.getMetadata(
      link: link,
      cache: const Duration(days: 7),
    );
    return Image.network(metadata!.image!,
        width: 100, height: 100, fit: BoxFit.fill);
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
