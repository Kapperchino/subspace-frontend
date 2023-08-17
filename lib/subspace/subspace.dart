import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
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

class Subspace extends StatefulWidget {
  const Subspace({super.key, required this.name, required this.parentId});

  final String name;
  final int parentId;

  @override
  State<StatefulWidget> createState() {
    return _SubSpaceState(parentId: parentId, name: name);
  }
}

class _SubSpaceState extends State<Subspace> {
  _SubSpaceState({
    required this.parentId,
    required this.name,
  });

  final String name;
  final int parentId;

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
          context
              .read<SpaceBloc>()
              .add(SpaceFetched(parentId: parentId, spaceName: name));
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
                        Container(
                          padding:
                              EdgeInsets.only(left: padding + 5, bottom: 5),
                          alignment: Alignment.bottomLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                                width: 300, height: 40),
                            child: TextField(
                              autofocus: false,
                              maxLines: 1,
                              onSubmitted: (value) {
                                bool isTag = false;
                                if (value.startsWith("#")) {
                                  value = value.substring(1);
                                  isTag = true;
                                }
                                context.push("/search/$value?isTag=$isTag");
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                filled: false,
                                hintText: 'Search',
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).cardColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(right: padding, bottom: 10),
                      alignment: Alignment.bottomRight,
                      child: BlocBuilder<SpaceBloc, SpaceState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () async {
                              context
                                  .push("/create/space/${state.spaceId}/post")
                                  .then((value) => context
                                      .read<SpaceBloc>()
                                      .add(SpaceFetched(
                                          parentId: parentId,
                                          spaceName: name)));
                            },
                            child: const Text('Post'),
                          );
                        },
                      ),
                    ),
                  ],
                )),
            backgroundColor: Theme.of(context).colorScheme.background,
            flexibleSpace: BlocBuilder<SpaceBloc, SpaceState>(
                builder: (context, state) => FlexibleSpaceBar(
                      background: getImage(state.backgroundPicture, fit),
                      titlePadding: const EdgeInsets.all(50),
                      title: TitleWidget(
                        title: name,
                      ),
                    )),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.only(left: padding, bottom: 0),
                    alignment: Alignment.topLeft,
                    child: const SortPostsWidget()),
                Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 0),
                    alignment: Alignment.bottomLeft,
                    child: const SortPostsDaysWidget())
              ],
            ),
          ),
          BlocBuilder<SpaceBloc, SpaceState>(
            builder: (context, state) {
              switch (state.status) {
                case SpaceStatus.failure:
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('failed to fetch posts')));
                case SpaceStatus.success:
                  if (name != "SubSpace") {
                    context.read<TitleBloc>().add(InitEvent(
                        context.read<SpaceBloc>().state.spaceId, name));
                  }
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
                              spaceName: name, post: state.posts[index].post);
                        }, childCount: state.posts.length,addRepaintBoundaries: false),
                      ));
                case SpaceStatus.initial:
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
                  .read<SpaceBloc>()
                  .add(SpaceSortChanged(sortState: state.status));
            },
            child: const SliverToBoxAdapter(child: SizedBox()),
          ),
          BlocListener<SortBloc, SortState>(
            listenWhen: 
            (previous, current) {
              return previous.sortDays != current.sortDays;
            },
            listener: (context, state) {
              context
                  .read<SpaceBloc>()
                  .add(DaysSortChanged(sortDays: state.sortDays));
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
