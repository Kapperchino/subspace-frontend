import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/common/navBar.dart';
import 'package:frontend/common/sidebar.dart';
import 'package:frontend/cubit/spaceHome/spaceHomeBloc.dart';
import 'package:frontend/cubit/spaceHome/spaceHomeState.dart';
import 'package:frontend/search/searchResult.dart';
import 'package:go_router/go_router.dart';

class SubSpaceHome extends StatelessWidget {
  SubSpaceHome({super.key});
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
            context.push("/create/space/1");
          },
        ),
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
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
                        "assets/search_background.png",
                        fit: fit,
                      ),
                      title: const Text("Spaces"),
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
                          text: "Popular",
                        ),
                        Tab(
                          height: 40,
                          text: "New",
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: BlocBuilder<SpaceHomeBloc, SpaceHomeState>(
              builder: (context, state) {
                return TabBarView(children: [
                  SafeArea(
                    top: false,
                    bottom: false,
                    child: Builder(
                      builder: (BuildContext context) {
                        return CustomScrollView(
                          cacheExtent: 8500,
                          key: const PageStorageKey<String>("Popular"),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            if (state.status == SpaceHomeStatus.failure)
                              const SliverToBoxAdapter(
                                  child: Center(
                                      child: Text('failed to fetch spaces'))),
                            if (state.status == SpaceHomeStatus.success)
                              SliverPadding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: padding),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      if (index >=
                                          state.popularSpaces!.length) {
                                        return const BottomLoader();
                                      }
                                      return SearchResult(
                                        space: state.popularSpaces![index],
                                      );
                                    }, childCount: state.popularSpaces!.length),
                                  )),
                            if (state.status == SpaceHomeStatus.initial)
                              const SliverToBoxAdapter(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                          ],
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
                          key: const PageStorageKey<String>("New"),
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                            ),
                            if (state.status == SpaceHomeStatus.failure)
                              const SliverToBoxAdapter(
                                  child: Center(
                                      child: Text('failed to fetch spaces'))),
                            if (state.status == SpaceHomeStatus.success)
                              SliverPadding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: padding),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      if (index >= state.latestSpaces!.length) {
                                        return const BottomLoader();
                                      }
                                      return SearchResult(
                                        space: state.latestSpaces![index],
                                      );
                                    }, childCount: state.latestSpaces!.length),
                                  )),
                            if (state.status == SpaceHomeStatus.initial)
                              const SliverToBoxAdapter(
                                  child: Center(
                                      child: CircularProgressIndicator())),
                          ],
                        );
                      },
                    ),
                  ),
                ]);
              },
            )),
      ),
    );
  }
}
