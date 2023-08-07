import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/timeWidget.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/cubit/space/spaceBlock.dart';
import 'package:frontend/posts/cubit/space/spaceState.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsState.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pictureMeta.dart';
import '../models/postCardData.dart';
import '../models/voteRequest.dart';
import '../util/constDetectable.dart';
import '../util/votesUtil.dart';
import 'cubit/vote/voteBloc.dart';
import 'package:http/http.dart' as http;

import 'cubit/vote/voteEvent.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.data, required this.spaceName});

  final PostCardData data;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    final post = data.post;
    final location = GoRouterState.of(context).matchedLocation;

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
                Flexible(
                    child: PostMeta(
                  spaceName: spaceName,
                  maxUserNameLength: 16,
                  post: data.post,
                )),
                if (post.topic.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      post.topic,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (post.body.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ConstDetectableText(
                      text: post.body,
                      basicStyle: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.left,
                      detectionRegExp: detectionRegExp()!,
                      overflow: TextOverflow.fade,
                      maxLines: 6,
                      trimMode: TrimMode.Length,
                      trimLines: 100,
                      onTap: (text) {
                        switch (text.characters.first) {
                          case "#":
                            {
                              text = text.substring(1);
                              context.push("/search/$text?isTag=true");
                            }
                          case "@":
                            {
                              print(text);
                            }
                        }
                      },
                    ),
                  ),
                if (post.type == ContentType.picture ||
                    post.type == ContentType.link)
                  FutureBuilder<Widget>(
                    future: getImage(post.postPictures, post.type),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.antiAlias,
                            child: snapshot.data);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (location.startsWith("/s/"))
                      BlocBuilder<SpaceBloc, SpaceState>(
                        builder: (context, state) {
                          context.read<VoteBloc>().add(InitEvent(
                              data.post.id,
                              data.post.upVotes,
                              data.post.downVotes,
                              VotesUtil.getStatus(data.post.vote),
                              VoteType.post));
                          return const VoteWidgetFlat();
                        },
                      ),
                    if (location.startsWith("/subscriptions"))
                      BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                        builder: (context, state) {
                          context.read<VoteBloc>().add(InitEvent(
                              data.post.id,
                              data.post.upVotes,
                              data.post.downVotes,
                              VotesUtil.getStatus(data.post.vote),
                              VoteType.post));
                          return const VoteWidgetFlat();
                        },
                      ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: TimeWidget(time: data.post.created),
                    )
                  ],
                )
              ]),
        ));
  }

  Future<Widget> getImage(List<PictureMeta>? pictures, ContentType type) async {
    var urlPrefix = "";
    if (kIsWeb) {
      urlPrefix = "https://subspace-cors.fly.dev/";
    }
    if (pictures == null) {
      return Image.memory(kTransparentImage);
    }
    const defaultRatio = 600 / 500;
    final imageRatio = pictures[0].width / pictures[0].height;
    var boxfit = BoxFit.fitWidth;
    final adjustedHeight = 600 / imageRatio;
    final double height = min(500.0, adjustedHeight);
    if (imageRatio < defaultRatio) {
      boxfit = BoxFit.cover;
    }
    if (type == ContentType.picture) {
      return CachedNetworkImage(
        imageUrl: "$urlPrefix${pictures[0].url}",
        placeholder: (context, url) => Image.memory(kTransparentImage),
        width: 600,
        height: height,
        fit: boxfit,
      );
    }
    Metadata? metadata = await AnyLinkPreview.getMetadata(
      link: "$urlPrefix${pictures[0].url}",
      cache: const Duration(days: 7),
    );
    if (metadata?.image == null) {
      return const SizedBox();
    }
    return CachedNetworkImage(
        imageUrl: "$urlPrefix${metadata!.image!}",
        placeholder: (context, url) => Image.memory(kTransparentImage),
        width: 600,
        fit: BoxFit.contain);
  }
}
