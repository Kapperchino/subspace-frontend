import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/post/postBloc.dart';
import 'package:frontend/posts/cubit/post/postEvent.dart';
import 'package:frontend/posts/post.dart';
import 'package:http/http.dart' as http;

import 'cubit/comment/commentBloc.dart';
import 'cubit/commenting/commentingBloc.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key, required this.id, required this.spaceName});

  final int id;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => CommentBloc(httpClient: http.Client())
                ..add(CommentsFetched(postId: id))),
          BlocProvider(
              create: (_) => CommentingBloc(
                  httpClient: http.Client(), postId: id, parentId: 1,isPostComment: true)),
          BlocProvider(
              create: (_) => PostBloc(httpClient: http.Client())
                ..add(PostFetched(postId: id)))
        ],
        child: PostWidget(
          id: id,
          spaceName: spaceName,
        ));
  }
}
