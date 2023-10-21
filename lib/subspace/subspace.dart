import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:frontend/cubit/space/spaceEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/title/titleBloc.dart';
import 'package:frontend/cubit/title/titleEvent.dart';
import 'package:frontend/common/navBar.dart';
import 'package:frontend/subspace/spaceAbout.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';

import '../cubit/space/spaceBlock.dart';
import '../cubit/space/spaceState.dart';
import '../posts/postCardWrapper.dart';
import '../common/sidebar.dart';

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
    final padding = max((width - 600) / 2, 8.0);
    var fit = BoxFit.fitHeight;
    return DefaultTabController(
      length: 2, // This is the number of tabs.
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        endDrawer: const SideBar(),
        floatingActionButton: BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            return FloatingActionButton(
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
              onPressed: () async {
                context.push("/create/space/${state.spaceId}/post").then(
                    (value) => context.read<SpaceBloc>().add(
                        SpaceFetched(parentId: parentId, spaceName: name)));
              },
            );
          },
        ),
        body: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              BlocBuilder<SpaceBloc, SpaceState>(
                builder: (context, state) {
                  return SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      // This is the title in the app bar.
                      pinned: false,
                      snap: false,
                      floating: false,
                      centerTitle: true,
                      stretchTriggerOffset: 10,
                      toolbarHeight: 137,
                      leading: const SizedBox(),
                      actions: <Widget>[
                        Container(),
                      ],
                      expandedHeight: 300,
                      forceElevated: innerBoxIsScrolled,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      flexibleSpace: Stack(
                        alignment: Alignment.center,
                        children: [
                          FlexibleSpaceBar(
                            background: ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                    Color.fromARGB(137, 45, 45, 45),
                                    BlendMode.darken),
                                child: Image.asset(
                                  "assets/default_space_background.png",
                                  fit: fit,
                                )),
                          ),
                          SafeArea(
                              top: false,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SpaceAbout(
                                      meta: state.spaceMeta,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 20))
                                  ])),
                        ],
                      ),
                      bottom: TabBar(
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        labelColor: Theme.of(context).colorScheme.secondary,
                        indicatorColor: Theme.of(context).colorScheme.secondary,
                        labelPadding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        // These are the widgets to put in each tab in the tab bar.
                        tabs: const [
                          Tab(
                            height: 40,
                            text: "Posts",
                          ),
                          Tab(
                            height: 40,
                            text: "About",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ];
          },
          body: TabBarView(children: [
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<SpaceBloc>().add(
                          SpaceFetched(parentId: parentId, spaceName: name));
                    },
                    child: CustomScrollView(
                        cacheExtent: 8500,
                        key: PageStorageKey<String>(name),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          const SliverPadding(
                              padding: EdgeInsets.only(bottom: 5)),
                          BlocBuilder<SpaceBloc, SpaceState>(
                            builder: (context, state) {
                              switch (state.status) {
                                case SpaceStatus.failure:
                                  return const SliverToBoxAdapter(
                                      child: Center(
                                          child:
                                              Text('failed to fetch posts')));
                                case SpaceStatus.success:
                                  if (name != "SubSpace") {
                                    context.read<TitleBloc>().add(InitEvent(
                                        context.read<SpaceBloc>().state.spaceId,
                                        name));
                                  }
                                  if (state.posts.isEmpty) {
                                    return const SliverToBoxAdapter(
                                        child: Center(child: Text('no posts')));
                                  }
                                  return SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: padding),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (index >= state.posts.length) {
                                              return const SliverToBoxAdapter(
                                                  child: BottomLoader());
                                            }
                                            return PostCardWrapper(
                                                data: state.posts[index]);
                                          },
                                          childCount: state.posts.length,
                                        ),
                                      ));
                                case SpaceStatus.initial:
                                  return const SliverToBoxAdapter(
                                      child: Center(
                                          child: CircularProgressIndicator()));
                              }
                            },
                          ),
                          BlocListener<SortBloc, SortState>(
                            listenWhen: (previous, current) {
                              return previous.status != current.status;
                            },
                            listener: (context, state) {
                              context.read<SpaceBloc>().add(
                                  SpaceSortChanged(sortState: state.status));
                            },
                            child: const SliverToBoxAdapter(child: SizedBox()),
                          ),
                          BlocListener<SortBloc, SortState>(
                            listenWhen: (previous, current) {
                              return previous.sortDays != current.sortDays;
                            },
                            listener: (context, state) {
                              context.read<SpaceBloc>().add(
                                  DaysSortChanged(sortDays: state.sortDays));
                            },
                            child: const SliverToBoxAdapter(child: SizedBox()),
                          )
                        ]),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    cacheExtent: 8500,
                    key: const PageStorageKey<String>("Following"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        ),
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
