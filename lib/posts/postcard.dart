import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/postCardData.dart';
import '../models/voteRequest.dart';
import '../util/votesUtil.dart';
import 'cubit/vote/voteBloc.dart';
import 'package:http/http.dart' as http;

import 'cubit/vote/voteEvent.dart';

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
                "/s/${data.post.spaceParentId}/${data.post.spaceName}/p/${post.id}");
          },
          child: Column(children: [
            PostMeta(
              userName: post.posterName,
              posterId: post.posterId,
              created: post.created,
              spaceName: post.spaceName,
              parentId: post.spaceParentId,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (post.type == ContentType.text)
                  const SizedBox(width: 30, height: 0),
                if (post.type == ContentType.picture ||
                    post.type == ContentType.link)
                  FutureBuilder<Widget>(
                    future: getImage(post.content, post.type),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                            flex: 5,
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
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10),
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
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                BlocProvider(
                  create: (_) => VoteBloc(
                    httpClient: http.Client(),
                    type: VoteType.post,
                  )..add(InitEvent(
                      data.post.id,
                      data.post.upVotes,
                      data.post.downVotes,
                      VotesUtil.getStatus(data.post.vote),
                      VoteType.post)),
                  child: const VoteWidgetFlat(),
                ),
              ],
            )
          ]),
        ));
  }

  Future<Widget> getImage(String link, ContentType type) async {
    var urlPrefix = "";
    if (kIsWeb) {
      urlPrefix = "https://subspace-cors.fly.dev/";
    }
    if (type == ContentType.picture) {
      return Image.network(
        "$urlPrefix$link",
        width: 100,
        height: 100,
        fit: BoxFit.fill,
      );
    }
    Metadata? metadata = await AnyLinkPreview.getMetadata(
      link: "$urlPrefix$link",
      cache: const Duration(days: 7),
    );
    if (metadata?.image == null) {
      return const SizedBox();
    }
    return Image.network(metadata!.image!,
        width: 100, height: 100, fit: BoxFit.fill);
  }
}
