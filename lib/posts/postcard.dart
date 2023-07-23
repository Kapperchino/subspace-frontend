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
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostMeta(
                  userName: post.posterName,
                  posterId: post.posterId,
                  created: post.created,
                  spaceName: post.spaceName,
                  parentId: post.spaceParentId,
                ),
                if (post.topic.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      post.topic,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                if (post.type == ContentType.picture ||
                    post.type == ContentType.link)
                  FutureBuilder<Widget>(
                    future: getImage(post.content, post.type),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Flexible(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: InkWell(
                                  onTap: () async {
                                    if (post.type == ContentType.link) {
                                      final Uri url = Uri.parse(post.content);
                                      if (!await launchUrl(url)) {
                                        throw Exception(
                                            'Could not launch $url');
                                      }
                                    }
                                  },
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(post.body,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.left,
                      maxLines: 4),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
        width: 600,
        fit: BoxFit.contain,
      );
    }
    Metadata? metadata = await AnyLinkPreview.getMetadata(
      link: "$urlPrefix$link",
      cache: const Duration(days: 7),
    );
    if (metadata?.image == null) {
      return const SizedBox();
    }
    return Image.network(width: 600, metadata!.image!, fit: BoxFit.contain);
  }
}
