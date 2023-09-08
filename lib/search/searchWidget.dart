import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/navBar.dart';
import 'package:frontend/cubit/search/searchEvent.dart';
import 'package:frontend/cubit/search/searchBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/search/searchPosts.dart';
import 'package:frontend/search/searchSpaces.dart';
import 'package:frontend/search/searchUsers.dart';

import '../cubit/sorting/sortBloc.dart';
import '../cubit/sorting/sortState.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({super.key});

  final TextEditingController controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 8.0);
    var fit = BoxFit.fitWidth;
    return DefaultTabController(
      length: 3, // This is the number of tabs.
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
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
                        text: "Posts",
                      ),
                      Tab(
                        height: 40,
                        text: "Spaces",
                      ),
                      Tab(
                        height: 40,
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
