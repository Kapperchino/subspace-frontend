import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/common/navBar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

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
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                  collapsedHeight: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      "assets/search_background.png",
                      fit: fit,
                    ),
                    title: const Text("Notifications"),
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
                        text: "All",
                      ),
                      Tab(
                        height: 40,
                        text: "Mentions",
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
                  return CustomScrollView(
                    cacheExtent: 8500,
                    key: const PageStorageKey<String>("AllNotifications"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
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
                    key: const PageStorageKey<String>("MentionNotifications"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      )
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
