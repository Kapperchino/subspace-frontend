
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/commentSection.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/postSection.dart';
import 'package:http/http.dart' as http;


class PostWidget extends StatelessWidget {
  const PostWidget(
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
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          snap: false,
          floating: false,
          expandedHeight: 160.0,
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(topic),
            background: const FlutterLogo(),
            titlePadding: const EdgeInsets.all(50),
          ),
        ),
        SliverToBoxAdapter(
            child: PostSection(
                topic: topic,
                likes: likes,
                body: body,
                userName: userName,
                spaceId: spaceId,
                posterId: posterId,
                dislikes: dislikes,
                parentSpaceId: parentSpaceId,
                spaceName: spaceName,
                id: id,
                created: created)),
        BlocProvider(
            create: (_) => CommentBloc(httpClient: http.Client())
              ..add((CommentsFetched(postId: id))),
            child: CommentSection(
              postId: id,
            )),
      ],
    ));
  }
}
