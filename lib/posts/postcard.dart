import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/timeWidget.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/cubit/search/searchBloc.dart';
import 'package:frontend/cubit/search/searchState.dart';
import 'package:frontend/cubit/space/spaceBlock.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsState.dart';
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
import '../cubit/vote/voteBloc.dart';

import '../cubit/vote/voteEvent.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, required this.spaceName});

  final Post post;
  final String spaceName;

  static const double CARD_MAX_HEIGHT = 600;
  static const double CARD_MAX_WIDTH = 600;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            context.push(
                "/s/${post.spaceParentId}/${post.spaceName}/p/${post.id}");
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
                  post: post,
                )),
                if (post.topic.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
                    future: getImage(
                        post.postPictures, post.type, post.link, context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        context.read<VoteBloc>().add(InitEvent(
                            post.id,
                            post.upVotes,
                            post.downVotes,
                            VotesUtil.getStatus(post.vote),
                            VoteType.post));
                        return const VoteWidgetFlat();
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 10),
                      child: TimeWidget(time: post.created),
                    )
                  ],
                )
              ]),
        ));
  }

  Future<Widget> getImage(List<PictureMeta>? pictures, ContentType type,
      String? link, BuildContext context) async {
    var urlPrefix = "";
    if (kIsWeb) {
      urlPrefix = "https://subspace-cors.fly.dev/";
    }
    if (type == ContentType.picture && pictures == null) {
      return const SizedBox();
    }
    if (type == ContentType.picture) {
      final deviceWidth = MediaQuery.of(context).size.width - 20;
      final maxWidth = min(deviceWidth, CARD_MAX_WIDTH);
      final defaultRatio = maxWidth / CARD_MAX_HEIGHT;
      final imageRatio = pictures![0].width / pictures[0].height;
      var boxfit = BoxFit.fitWidth;
      final adjustedHeight = maxWidth / imageRatio;
      final double height = min(CARD_MAX_HEIGHT, adjustedHeight);
      if (imageRatio < defaultRatio) {
        boxfit = BoxFit.cover;
      }
      return InkWell(
          onTap: () {
            if (kIsWeb) {
              BrowserContextMenu.disableContextMenu().then((value) =>
                  context.push("/images/${pictures[0].id}").then((value) async {
                    await BrowserContextMenu.enableContextMenu();
                  }));
            } else {
              context.push("/images/${pictures[0].id}");
            }
          },
          child: CachedNetworkImage(
            imageUrl: "$urlPrefix${pictures[0].url}",
            placeholder: (context, url) => Image.memory(
              kTransparentImage,
              width: CARD_MAX_WIDTH,
              height: adjustedHeight,
            ),
            width: CARD_MAX_WIDTH,
            height: height,
            fit: boxfit,
          ));
    } else if (type == ContentType.link) {
      return Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AnyLinkPreview(
                  link: "$urlPrefix$link",
                  displayDirection: UIDirection.uiDirectionVertical,
                  showMultimedia: true,
                  bodyMaxLines: 3,
                  bodyTextOverflow: TextOverflow.ellipsis,
                  bodyStyle: Theme.of(context).textTheme.bodyLarge,
                  titleStyle: Theme.of(context).textTheme.titleLarge,
                  previewHeight: 500,
                  errorBody: 'Error!',
                  errorTitle: 'Error!',
                  errorWidget: Container(
                    color: Colors.grey[300],
                    child: const Text('Oops!'),
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  borderRadius: 12,
                  onTap: () async {
                    final Uri url = Uri.parse(link!);
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  })));
    }
    return const SizedBox();
  }
}
