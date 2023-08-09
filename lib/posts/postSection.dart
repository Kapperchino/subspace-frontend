import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/commentingWidget.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/commenting/commentingBloc.dart';
import 'package:frontend/posts/cubit/commenting/commentingState.dart';
import 'package:frontend/posts/cubit/post/postBloc.dart';
import 'package:frontend/posts/cubit/post/postState.dart';
import 'package:frontend/posts/postMeta.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:frontend/util/selectableDetectables.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pictureMeta.dart';
import '../models/voteRequest.dart';
import '../util/votesUtil.dart';
import 'cubit/commenting/commentingEvent.dart';
import 'cubit/vote/voteBloc.dart';
import 'package:http/http.dart' as http;

import 'cubit/vote/voteEvent.dart';

class PostSection extends StatelessWidget {
  const PostSection({super.key, required this.id, required this.spaceName});
  final int id;
  final String spaceName;

  static const double CARD_MAX_HEIGHT = 600;
  static const double CARD_MAX_WIDTH = 600;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 800) / 2, 0.0);
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state.status == PostStatus.success) {
        var urlPrefix = "";
        if (kIsWeb) {
          urlPrefix = "https://subspace-cors.fly.dev/";
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Card(
              margin: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (state.post!.topic.isEmpty)
                    const SizedBox(
                      height: 10,
                    ),
                  if (state.post!.topic.isNotEmpty)
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: SelectableText(
                        state.post!.topic,
                        style: Theme.of(context).textTheme.titleLarge,
                        textScaleFactor: 1.5,
                      ),
                    )),
                  if (state.post!.type == ContentType.text)
                    const SizedBox(width: 0, height: 0),
                  if (state.post!.type == ContentType.picture ||
                      state.post!.type == ContentType.link)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FutureBuilder<Widget>(
                        future: getImage(state.post!.postPictures,
                            state.post!.type, state.post!.link, context),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  if (state.post!.body.isNotEmpty)
                    Flexible(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: SelectableDetectable(
                                    text: state.post!.body,
                                    textAlign: TextAlign.left,
                                    detectionRegExp: detectionRegExp()!,
                                    trimMode: TrimMode.Line,
                                    trimLines: 100,
                                    onTap: (text) {
                                      switch (text.characters.first) {
                                        case "#":
                                          {
                                            print(text);
                                          }
                                        case "@":
                                          {
                                            print(text);
                                          }
                                      }
                                    })))),
                  Flexible(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: PostMeta(
                          spaceName: spaceName,
                          post: state.post!,
                          maxUserNameLength: 50,
                        )),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      BlocProvider(
                        create: (_) => VoteBloc(
                          httpClient: http.Client(),
                          type: VoteType.post,
                        )..add(InitEvent(
                            id,
                            state.post!.upVotes,
                            state.post!.downVotes,
                            VotesUtil.getStatus(state.post!.vote),
                            VoteType.post)),
                        child: const VoteWidgetFlat(),
                      ),
                      Flexible(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      context
                                          .read<CommentingBloc>()
                                          .add(CommentPressed(postId: id));
                                    },
                                    child: const Text('Comment'),
                                  )))),
                    ],
                  ),
                ],
              ),
            )),
            const Flexible(child: CommentingWidget()),
            BlocListener<CommentingBloc, CommentingState>(
              listener: (context, state) {
                ScaffoldMessenger.of(context).clearSnackBars();
                if (state.status == CommentingStaus.success) {
                  BlocProvider.of<CommentBloc>(context)
                      .add(CommentsFetched(postId: id));
                  state.controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Comment created')));
                } else if (state.status == CommentingStaus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
      return CachedNetworkImage(
        imageUrl: "$urlPrefix${pictures[0].url}",
        placeholder: (context, url) => Image.memory(
          kTransparentImage,
          width: CARD_MAX_WIDTH,
          height: adjustedHeight,
        ),
        width: CARD_MAX_WIDTH,
        height: height,
        fit: boxfit,
      );
    } else if (type == ContentType.link) {
      return Flexible(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
                  }
                  // This disables tap event
                  )));
    }
    return const SizedBox();
  }
}
