import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/commentSection.dart';
import 'package:frontend/posts/cubit/comment/commentBloc.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/commenting/commentingBloc.dart';
import 'package:frontend/posts/postSection.dart';
import 'package:http/http.dart' as http;

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.id, required this.spaceName});

  final int id;
  final String spaceName;

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
            title: Text(spaceName),
            background: const FlutterLogo(),
            titlePadding: const EdgeInsets.all(50),
          ),
        ),
        SliverToBoxAdapter(
            child: PostSection(
          spaceName: spaceName,
          id: id,
        )),
        CommentSection(postId: id)
      ],
    ));
  }
}
