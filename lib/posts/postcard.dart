import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/timeWidget.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/videoMeta.dart';
import 'package:frontend/posts/commentCount.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/pictureMeta.dart';
import '../models/voteRequest.dart';
import '../util/constDetectable.dart';
import '../util/votesUtil.dart';
import '../cubit/vote/voteBloc.dart';

import '../cubit/vote/voteEvent.dart';

class PostCard extends StatelessWidget {
  PostCard(
      {super.key, required this.post, this.chewieController, this.controller});

  final Post post;

  static const double CARD_MAX_HEIGHT = 600;
  static const double CARD_MAX_WIDTH = 600;

  VideoPlayerController? controller;
  ChewieController? chewieController;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        child: InkWell(
            onTap: () {
              context.push(
                  "/s/${post.spaceParentId}/${post.spaceName}/p/${post.id}");
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Flexible(
                        child: PostMeta(
                      spaceName: post.spaceName,
                      maxUserNameLength: 16,
                      post: post,
                    ))),
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.topic.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
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
                                    context.push(
                                        "/search/results/$text?isTag=true");
                                  }
                                case "@":
                                  {}
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
                              if (post.postPictures != null) {
                                final deviceWidth =
                                    MediaQuery.of(context).size.width - 20;
                                final maxWidth =
                                    min(deviceWidth, CARD_MAX_WIDTH);
                                final imageRatio = post.postPictures![0].width /
                                    post.postPictures![0].height;
                                final adjustedHeight = maxWidth / imageRatio;
                                final double height =
                                    min(CARD_MAX_HEIGHT, adjustedHeight);
                                return SizedBox(
                                  width: maxWidth,
                                  height: height,
                                );
                              }
                              return const SizedBox();
                            }
                          },
                        ),
                      if (post.type == ContentType.video)
                        getVideo(post.postVideos),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          TimeWidget(time: post.created),
                          const Spacer(),
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
                          const Padding(padding: EdgeInsets.only(right: 5)),
                          CommentCount(
                            count: post.commentsCount,
                            post: post,
                          ),
                          const Padding(
                              padding: EdgeInsets.only(right: 5, bottom: 10)),
                        ],
                      )
                    ])
              ],
            )));
  }

  Widget getVideo(List<VideoMeta>? videos) {
    if (videos == null) {
      return const SizedBox();
    }
    if (videos[0].status != 'done') {
      return const SizedBox();
    }
    controller ??= VideoPlayerController.networkUrl(Uri.parse(videos[0].url))
      ..initialize();

    chewieController ??= ChewieController(
        videoPlayerController: controller!,
        aspectRatio: videos[0].width / videos[0].height,
        autoPlay: false,
        looping: false,
        placeholder: Image.network(
          videos[0].thumbnail,
          width: videos[0].width.toDouble(),
          height: videos[0].height.toDouble(),
        ),
        showControlsOnInitialize: false,
        allowPlaybackSpeedChanging: false);

    return VisibilityDetector(
        key: Key(post.id.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction > 0.6) {
          } else {
            chewieController?.pause();
          }
        },
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    height:
                        min(videos[0].height.toDouble(), CARD_MAX_HEIGHT - 250),
                    width:
                        min(videos[0].width.toDouble(), CARD_MAX_WIDTH - 250),
                    child: Chewie(
                      controller: chewieController!,
                    )))));
  }

  Future<Widget> getImage(List<PictureMeta>? pictures, ContentType type,
      String? link, BuildContext context) async {
    var urlPrefix = "";
    if (type == ContentType.picture && pictures == null) {
      return const SizedBox();
    }
    if (type == ContentType.picture) {
      final deviceWidth = MediaQuery.of(context).size.width - 40;
      final maxWidth = min(deviceWidth, CARD_MAX_WIDTH);
      final defaultRatio = maxWidth / CARD_MAX_HEIGHT;
      final imageRatio = pictures![0].width / pictures[0].height;
      var boxfit = BoxFit.fitWidth;
      final adjustedHeight = maxWidth / imageRatio;
      final double height = min(CARD_MAX_HEIGHT, adjustedHeight);
      if (imageRatio < defaultRatio) {
        boxfit = BoxFit.cover;
      }
      final cachedRatio =
          min(pictures[0].width / maxWidth, pictures[0].height / height);
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                  onTap: () {
                    context.push("/images/${pictures[0].id}");
                  },
                  child: CachedNetworkImage(
                    imageUrl: "$urlPrefix${pictures[0].url}",
                    placeholder: (context, url) => Image.memory(
                      kTransparentImage,
                      width: maxWidth,
                      height: height,
                    ),
                    width: maxWidth,
                    height: height,
                    filterQuality: FilterQuality.medium,
                    memCacheHeight: (height * cachedRatio).round(),
                    memCacheWidth: (maxWidth * cachedRatio).round(),
                    fit: boxfit,
                  ))));
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
