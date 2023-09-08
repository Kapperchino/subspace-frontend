import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/navBar.dart';
import 'package:frontend/cubit/comment/commentBloc.dart';
import 'package:frontend/cubit/comment/commentEvent.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/posts/commentSection.dart';
import 'package:frontend/cubit/post/postBloc.dart';
import 'package:frontend/cubit/post/postEvent.dart';
import 'package:frontend/cubit/post/postState.dart';
import 'package:frontend/posts/postSection.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/sorting/sortBloc.dart';
import '../cubit/sorting/sortState.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.id, required this.spaceName});

  final int id;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    var fit = BoxFit.none;
    fit = BoxFit.fitWidth;
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 8.0);
    return Scaffold(
        bottomNavigationBar: const NavBar(),
        body: RefreshIndicator(onRefresh: () async {
          context.read<PostBloc>().add(PostFetched(postId: id));
        }, child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  snap: false,
                  floating: false,
                  centerTitle: true,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    background: getImage(state.post?.spacePicture, fit),
                    title: Text(spaceName),
                  ),
                ),
                SliverToBoxAdapter(
                    child: PostSection(
                  spaceName: spaceName,
                  id: id,
                )),
                BlocListener<SortBloc, SortState>(
                  listenWhen: (previous, current) {
                    return previous.status != current.status;
                  },
                  listener: (context, state) {
                    context
                        .read<CommentBloc>()
                        .add(CommentsSortChange(sortStatus: state.status));
                  },
                  child: const SliverToBoxAdapter(child: SizedBox()),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 10)),
                CommentSection(postId: id)
              ],
            );
          },
        )));
  }

  Widget getImage(PictureMeta? picture, BoxFit fit) {
    if (picture == null) {
      return Image.asset(
        "assets/default_space_background.png",
        fit: fit,
      );
    }
    return CachedNetworkImage(
      imageUrl: picture.url,
      placeholder: (context, url) => Image.memory(kTransparentImage),
      fit: fit,
    );
  }
}
