import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/commentSection.dart';
import 'package:frontend/posts/cubit/post/postBloc.dart';
import 'package:frontend/posts/cubit/post/postEvent.dart';
import 'package:frontend/posts/cubit/post/postState.dart';
import 'package:frontend/posts/postSection.dart';
import 'package:transparent_image/transparent_image.dart';

import '../subspace/titleWidget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.id, required this.spaceName});

  final int id;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    var fit = BoxFit.none;
    if (kIsWeb) {
      fit = BoxFit.fitWidth;
    } else {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        fit = BoxFit.fitWidth;
      } else {
        fit = BoxFit.fitHeight;
      }
    }
    return Scaffold(
        body: RefreshIndicator(onRefresh: () async {
      context.read<PostBloc>().add(PostFetched(postId: id));
    }, child: BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              centerTitle: true,
              pinned: false,
              snap: false,
              floating: false,
              expandedHeight: 200.0,
              backgroundColor: Theme.of(context).colorScheme.background,
              flexibleSpace: FlexibleSpaceBar(
                background: getImage(state.post?.spacePicture, fit),
                titlePadding: const EdgeInsets.all(50),
                title: Text(spaceName),
              ),
            ),
            SliverToBoxAdapter(
                child: PostSection(
              spaceName: spaceName,
              id: id,
            )),
            CommentSection(postId: id)
          ],
        );
      },
    )));
  }

  Widget getImage(String? url, BoxFit fit) {
    if (url == null || url.isEmpty) {
      return Image.asset(
        "assets/default_space_background.png",
        fit: fit,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Image.memory(kTransparentImage),
      fit: fit,
    );
  }
}
