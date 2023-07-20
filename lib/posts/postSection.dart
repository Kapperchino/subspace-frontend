import 'dart:math';

import 'package:any_link_preview/any_link_preview.dart';
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
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
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
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      state.post!.topic,
                      style: Theme.of(context).textTheme.titleLarge,
                      textScaleFactor: 1.5,
                    ),
                  )),
                  if (state.post!.type == ContentType.text)
                    const SizedBox(width: 0, height: 0),
                  if (state.post!.type == ContentType.picture)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        "$urlPrefix${state.post!.content}",
                        width: 600,
                        height: 600,
                        fit: BoxFit.fill,
                      ),
                    ),
                  if (state.post!.type == ContentType.link)
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: AnyLinkPreview(
                                link: "$urlPrefix${state.post!.content}",
                                displayDirection:
                                    UIDirection.uiDirectionVertical,
                                showMultimedia: true,
                                bodyMaxLines: 3,
                                bodyTextOverflow: TextOverflow.ellipsis,
                                bodyStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
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
                                  final Uri url =
                                      Uri.parse(state.post!.content);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                }
                                // This disables tap event
                                ))),
                  Flexible(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Text(
                                state.post!.body,
                                textAlign: TextAlign.left,
                              )))),
                  Flexible(
                      child: PostMeta(
                          userName: state.post!.posterName,
                          posterId: state.post!.posterId,
                          created: state.post!.created,
                          parentId: state.post!.spaceParentId,
                          spaceName: spaceName)),
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
}
