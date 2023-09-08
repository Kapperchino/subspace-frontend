import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/common/sidebar.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:frontend/cubit/space/spaceBlock.dart';
import 'package:frontend/cubit/space/spaceEvent.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsEvent.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsState.dart';
import 'package:frontend/common/navBar.dart';
import 'package:frontend/posts/postCardWrapper.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 8.0);
    var fit = BoxFit.none;
    fit = BoxFit.fitWidth;
    return DefaultTabController(
      length: 2, // This is the number of tabs.
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        endDrawer: const SideBar(),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            context.push("/create/space/1/post").then((value) => context
                .read<SpaceBloc>()
                .add(SpaceFetched(parentId: 1, spaceName: "SubSpace")));
          },
        ),
        body: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  // This is the title in the app bar.
                  pinned: true,
                  snap: false,
                  floating: false,
                  centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  toolbarHeight: 0,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      "assets/default_space_background.png",
                      fit: fit,
                    ),
                    title: const Text("Subspace"),
                  ),
                  bottom: TabBar(
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    labelColor: Theme.of(context).colorScheme.secondary,
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: const [
                      Tab(
                        height: 40,
                        text: "Home",
                      ),
                      Tab(
                        height: 40,
                        text: "Following",
                      ),
                    ],
                  ),
                ),
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
                      displacement: 100,
                      onRefresh: () async {
                        context.read<SpaceBloc>().add(
                            SpaceFetched(parentId: 1, spaceName: "SubSpace"));
                      },
                      child: CustomScrollView(
                        cacheExtent: 8500,
                        key: const PageStorageKey<String>("Home"),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          BlocBuilder<SpaceBloc, SpaceState>(
                            builder: (context, state) {
                              switch (state.status) {
                                case SpaceStatus.failure:
                                  return const SliverToBoxAdapter(
                                      child: Center(
                                          child:
                                              Text('failed to fetch posts')));
                                case SpaceStatus.success:
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
                                                spaceName: "home",
                                                post: state.posts[index].post);
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
                        ],
                      ));
                },
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return RefreshIndicator(
                      displacement: 100,
                      onRefresh: () async {
                        context
                            .read<SubscriptionsBloc>()
                            .add(SubscriptionsFetched());
                      },
                      child: CustomScrollView(
                        cacheExtent: 8500,
                        key: const PageStorageKey<String>("Following"),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                            builder: (context, state) {
                              switch (state.status) {
                                case SubscriptionsStatus.failure:
                                  return const SliverToBoxAdapter(
                                      child: Center(
                                          child:
                                              Text('failed to fetch posts')));
                                case SubscriptionsStatus.success:
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
                                            post: state.posts[index].post,
                                            spaceName: "",
                                          );
                                        }, childCount: state.posts.length),
                                      ));
                                case SubscriptionsStatus.initial:
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
                              context.read<SubscriptionsBloc>().add(
                                  SubscriptionsSortChanged(
                                      sortState: state.status));
                            },
                            child: const SliverToBoxAdapter(child: SizedBox()),
                          ),
                          BlocListener<SortBloc, SortState>(
                            listenWhen: (previous, current) {
                              return previous.sortDays != current.sortDays;
                            },
                            listener: (context, state) {
                              context.read<SubscriptionsBloc>().add(
                                  SubscriptionDaysSortChanged(
                                      sortDays: state.sortDays));
                            },
                            child: const SliverToBoxAdapter(child: SizedBox()),
                          )
                        ],
                      ));
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
