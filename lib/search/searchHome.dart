import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/common/navBar.dart';
import 'package:frontend/common/sidebar.dart';
import 'package:frontend/cubit/trending/trendingBloc.dart';
import 'package:frontend/cubit/trending/trendingState.dart';
import 'package:frontend/models/tagMeta.dart';
import 'package:frontend/search/tagWidget.dart';
import 'package:go_router/go_router.dart';

class SearchHome extends StatelessWidget {
  SearchHome({super.key});

  bool hide = false;

  final TextEditingController controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 8.0);
    var fit = BoxFit.none;
    fit = BoxFit.fitWidth;
    return DefaultTabController(
      length: 3, // This is the number of tabs.
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        endDrawer: const SideBar(),
        body: NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
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
                      "assets/default_subscription_background.png",
                      fit: fit,
                    ),
                    title: TextField(
                      onSubmitted: (value) {
                        context.push(
                            "/search/results/${controllerSearch.text}?isTag=false");
                      },
                      style: const TextStyle(fontSize: 12),
                      controller: controllerSearch,
                      decoration: InputDecoration(
                          hintText: "Search",
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 25, minHeight: 25),
                          filled: true,
                          constraints: const BoxConstraints(
                              maxHeight: 20, maxWidth: 110),
                          prefixIcon: const Icon(Icons.search_outlined),
                          contentPadding: const EdgeInsets.only(right: 5),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      cursorHeight: 15,
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 50),
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
                        text: "Trending",
                      ),
                      Tab(
                        height: 40,
                        text: "News",
                      ),
                      Tab(
                        height: 40,
                        text: "Sports",
                      )
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
                  return CustomScrollView(
                    cacheExtent: 8500,
                    key: const PageStorageKey<String>("Trending"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      BlocBuilder<TrendingBloc, TrendingState>(
                        builder: (context, state) {
                          switch (state.status) {
                            case TrendingStatus.failure:
                              return const SliverToBoxAdapter(
                                  child: Center(
                                      child: Text('failed to fetch posts')));
                            case TrendingStatus.success:
                              if (state.tags!.isEmpty) {
                                return const SliverToBoxAdapter(
                                    child: Center(child: Text('no posts')));
                              }
                              return SliverPadding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: padding),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        if (index >= state.tags!.length) {
                                          return const SliverToBoxAdapter(
                                              child: BottomLoader());
                                        }
                                        return TagWidget(
                                            tag: state.tags![index]);
                                      },
                                      childCount: state.tags!.length,
                                    ),
                                  ));
                            case TrendingStatus.initial:
                              return const SliverToBoxAdapter(
                                  child: Center(
                                      child: CircularProgressIndicator()));
                          }
                        },
                      )
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
                    key: const PageStorageKey<String>("News"),
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
            SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    cacheExtent: 8500,
                    key: const PageStorageKey<String>("Sports"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
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
}
