import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/videoMeta.dart';
import 'package:frontend/posts/commentingWidget.dart';
import 'package:frontend/cubit/comment/commentBloc.dart';
import 'package:frontend/cubit/comment/commentEvent.dart';
import 'package:frontend/cubit/commenting/commentingBloc.dart';
import 'package:frontend/cubit/commenting/commentingState.dart';
import 'package:frontend/cubit/post/postBloc.dart';
import 'package:frontend/cubit/post/postState.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:frontend/util/selectableDetectables.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../common/timeWidget.dart';
import '../models/pictureMeta.dart';
import '../models/voteRequest.dart';
import '../util/votesUtil.dart';
import '../cubit/vote/voteBloc.dart';
import 'package:http/http.dart' as http;

import '../cubit/vote/voteEvent.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key, required this.id, required this.spaceName});
  final int id;
  final String spaceName;

  static const double CARD_MAX_HEIGHT = 600;
  static const double CARD_MAX_WIDTH = 600;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 8.0);
    return BlocBuilder<PostBloc, PostState>(builder: (context, postState) {
      if (postState.status == PostStatus.success) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Card(
              margin: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (postState.post!.topic.isEmpty)
                    const SizedBox(
                      height: 10,
                    ),
                  if (postState.post!.topic.isNotEmpty)
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: SelectableText(
                        postState.post!.topic,
                        style: Theme.of(context).textTheme.titleLarge,
                        textScaleFactor: 1.5,
                      ),
                    )),
                  if (postState.post!.type == ContentType.text)
                    const SizedBox(width: 0, height: 0),
                  if (postState.post!.type == ContentType.picture ||
                      postState.post!.type == ContentType.link)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FutureBuilder<Widget>(
                        future: getImage(
                            postState.post!.postPictures,
                            postState.post!.type,
                            postState.post!.link,
                            context),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return const CircularProgressIndicator.adaptive();
                          }
                        },
                      ),
                    ),
                  if (postState.post?.type == ContentType.video)
                    getVideo(postState.post?.postVideos, postState, context),
                  if (postState.post!.body.isNotEmpty)
                    Flexible(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: SelectableDetectable(
                                    text: postState.post!.body,
                                    textAlign: TextAlign.left,
                                    detectionRegExp: detectionRegExp()!,
                                    trimMode: TrimMode.Line,
                                    trimLines: 100,
                                    onTap: (text) {
                                      switch (text.characters.first) {
                                        case "#":
                                          {}
                                        case "@":
                                          {}
                                      }
                                    })))),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: PostMeta(
                              spaceName: spaceName,
                              post: postState.post!,
                              maxUserNameLength: 50,
                            )),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: TimeWidget(time: postState.post!.created),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(),
                      BlocProvider(
                        create: (_) => VoteBloc(
                          httpClient: http.Client(),
                          type: VoteType.post,
                        )..add(InitEvent(
                            id,
                            postState.post!.upVotes,
                            postState.post!.downVotes,
                            VotesUtil.getStatus(postState.post!.vote),
                            VoteType.post)),
                        child: const VoteWidgetFlat(),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 10)),
                      CommentingWidget(
                        post: postState.post,
                      ),
                    ],
                  ),
                ],
              ),
            )),
            BlocListener<CommentingBloc, CommentingState>(
              listener: (commentContext, state) {
                ScaffoldMessenger.of(commentContext).clearSnackBars();
                if (state.status == CommentingStaus.success) {
                  BlocProvider.of<CommentBloc>(commentContext)
                      .add(CommentsFetched(postId: id));
                  state.controller.clear();
                  ScaffoldMessenger.of(commentContext).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Comment created')));
                } else if (state.status == CommentingStaus.failure) {
                  ScaffoldMessenger.of(commentContext).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error input')));
                }
              },
              child: const SizedBox(),
            )
          ],
        );
      }
      return const CircularProgressIndicator.adaptive();
    });
  }

  Widget getVideo(
      List<VideoMeta>? videos, PostState state, BuildContext context) {
    if (videos == null) {
      return const SizedBox();
    }
    if (videos[0].status != 'done') {
      return const SizedBox();
    }
    final deviceWidth = MediaQuery.of(context).size.width - 40;
    final maxWidth = min(deviceWidth, CARD_MAX_WIDTH);
    final imageRatio = videos[0].width / videos[0].height;
    final adjustedHeight = maxWidth / imageRatio;
    final double height = min(CARD_MAX_HEIGHT, adjustedHeight);
    final ratio = min(videos[0].width / maxWidth, videos[0].height / height);
    return VisibilityDetector(
        key: Key(state.post!.id.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction > 0.6) {
          } else {
            state.chewieController?.pause();
          }
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                    height: height,
                    width: maxWidth * ratio,
                    child: Chewie(
                      controller: state.chewieController!,
                    )))));
  }

  Future<Widget> getImage(List<PictureMeta>? pictures, ContentType type,
      String? link, BuildContext context) async {
    var urlPrefix = "";
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
      final cachedRatio =
          min(pictures[0].width / maxWidth, pictures[0].height / height);
      return InkWell(
          onTap: () {
            context.push("/images/${pictures[0].id}");
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: "$urlPrefix${pictures[0].url}",
                placeholder: (context, url) => Image.memory(
                  kTransparentImage,
                  width: maxWidth,
                  height: height,
                ),
                width: maxWidth,
                height: height,
                memCacheHeight: (height * cachedRatio).round(),
                memCacheWidth: (maxWidth * cachedRatio).round(),
                fit: boxfit,
              )));
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
