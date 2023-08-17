import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/cubit/search/searchEvent.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/cubit/search/searchBloc.dart';
import 'package:frontend/cubit/search/searchState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/search/searchPosts.dart';
import 'package:frontend/search/searchResult.dart';
import 'package:frontend/search/searchSpaces.dart';
import 'package:frontend/search/searchUsers.dart';

import '../cubit/sorting/sortBloc.dart';
import '../cubit/sorting/sortState.dart';
import '../posts/postCardWrapper.dart';
import '../subspace/sortPostsDaysWidget.dart';
import '../subspace/sortPostsWidget.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({super.key});

  final TextEditingController controllerSearch = TextEditingController();
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
    return DefaultTabController(
      length: 3, // This is the number of tabs.
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                // This widget takes the overlapping behavior of the SliverAppBar,
                // and redirects it to the SliverOverlapInjector below. If it is
                // missing, then it is possible for the nested "inner" scroll view
                // below to end up under the SliverAppBar even when the inner
                // scroll view thinks it has not been scrolled.
                // This is not necessary if the "headerSliverBuilder" only builds
                // widgets that do not overlap the next sliver.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  // This is the title in the app bar.
                  pinned: false,
                  snap: false,
                  floating: false,
                  expandedHeight: 200,
                  centerTitle: true,
                  forceElevated: innerBoxIsScrolled,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      "assets/search_background.png",
                      fit: fit,
                    ),
                    titlePadding: const EdgeInsets.all(50),
                    title: const Text("Search"),
                  ),
                  bottom: const TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    tabs: [
                      Tab(
                        text: "Posts",
                      ),
                      Tab(
                        text: "Spaces",
                      ),
                      Tab(
                        text: "Users",
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
                    key: const PageStorageKey<String>("Post"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Container(
                                padding:
                                    EdgeInsets.only(left: padding, bottom: 0),
                                alignment: Alignment.topLeft,
                                child: const SortPostsWidget()),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 0),
                                alignment: Alignment.bottomLeft,
                                child: const SortPostsDaysWidget()),
                            BlocListener<SortBloc, SortState>(
                              listenWhen: (previous, current) {
                                return previous.status != current.status;
                              },
                              listener: (context, state) {
                                context.read<SearchBloc>().add(
                                    SearchSortChanged(status: state.status));
                              },
                              child: const SizedBox(),
                            ),
                            BlocListener<SortBloc, SortState>(
                              listenWhen: (previous, current) {
                                return previous.sortDays != current.sortDays;
                              },
                              listener: (context, state) {
                                context.read<SearchBloc>().add(
                                    SearchSortDaysChanged(
                                        days: state.sortDays));
                              },
                              child: const SizedBox(),
                            )
                          ],
                        ),
                      ),
                      const SearchPosts()
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
                    key: const PageStorageKey<String>("Space"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      const SearchSpaces()
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
                    key: const PageStorageKey<String>("Users"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      const SearchUsers()
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
