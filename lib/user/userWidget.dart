import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/cubit/userPage/userPageBloc.dart';
import 'package:frontend/cubit/userPage/userPageEvent.dart';
import 'package:frontend/cubit/userPage/userPageState.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:frontend/cubit/space/spaceEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/title/titleBloc.dart';
import 'package:frontend/cubit/title/titleEvent.dart';
import 'package:frontend/subspace/sortPostsDaysWidget.dart';
import 'package:frontend/subspace/sortPostsWidget.dart';
import 'package:frontend/subspace/titleWidget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/space/spaceBlock.dart';
import '../cubit/space/spaceState.dart';
import '../posts/postCardWrapper.dart';
import '../sidebar/sidebar.dart';
import '../stores/store.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key, required this.userId});

  final int userId;

  @override
  State<StatefulWidget> createState() {
    return _UserWidgetState(userId: userId);
  }
}

class _UserWidgetState extends State<UserWidget> {
  _UserWidgetState({required this.userId});

  final int userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 0.0);
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
      endDrawer: const SideBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<UserPageBloc>().add(UserPageFetched(userId: userId));
        },
        child: CustomScrollView(cacheExtent: 8500, slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            snap: false,
            floating: false,
            expandedHeight: 200,
            centerTitle: true,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(
                                        left: padding, bottom: 10),
                                    alignment: Alignment.topLeft,
                                    child: const SortPostsWidget()),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, bottom: 10),
                                    alignment: Alignment.bottomLeft,
                                    child: const SortPostsDaysWidget())
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            backgroundColor: Theme.of(context).colorScheme.background,
            flexibleSpace: FlexibleSpaceBar(
              background: getImage(null, fit),
              titlePadding: const EdgeInsets.all(50),
            ),
          ),
          BlocBuilder<UserPageBloc, UserPageState>(
            builder: (context, state) {
              switch (state.status) {
                case UserPageStatus.failure:
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('failed to fetch posts')));
                case UserPageStatus.success:
                  if (state.posts.isEmpty) {
                    return const SliverToBoxAdapter(
                        child: Center(child: Text('no posts')));
                  }
                  return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (index >= state.posts.length) {
                            return const SliverToBoxAdapter(
                                child: BottomLoader());
                          }
                          return PostCardWrapper(
                              spaceName: state.posts[index].spaceName,
                              post: state.posts[index]);
                        }, childCount: state.posts.length),
                      ));
                case UserPageStatus.initial:
                  return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
          BlocListener<SortBloc, SortState>(
            listenWhen: (previous, current) {
              return previous.status != current.status;
            },
            listener: (context, state) {
              context
                  .read<UserPageBloc>()
                  .add(UserPageSortChanged(sortState: state.status));
            },
            child: const SliverToBoxAdapter(child: SizedBox()),
          ),
          BlocListener<SortBloc, SortState>(
            listenWhen: (previous, current) {
              return previous.sortDays != current.sortDays;
            },
            listener: (context, state) {
              context
                  .read<UserPageBloc>()
                  .add(UserPageDaysSortChanged(sortDays: state.sortDays));
            },
            child: const SliverToBoxAdapter(child: SizedBox()),
          )
        ]),
      ),
    );
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
