import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsEvent.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsState.dart';
import 'package:frontend/subspace/sortPostsDaysWidget.dart';
import 'package:frontend/subspace/sortPostsWidget.dart';
import 'package:go_router/go_router.dart';

import '../posts/cubit/sorting/sortBloc.dart';
import '../posts/cubit/sorting/sortState.dart';
import '../posts/postcard.dart';

class SubscriptionsWidget extends StatefulWidget {
  const SubscriptionsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubscriptionsWidget();
  }
}

class _SubscriptionsWidget extends State<SubscriptionsWidget> {
  _SubscriptionsWidget();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Scaffold(
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Container(),
            ),
            ListTile(
              title: const Text('Create Subspace'),
              onTap: () {
                context.push("/create/space/1");
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          centerTitle: true,
          pinned: false,
          snap: false,
          floating: false,
          expandedHeight: 200.0,
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
          flexibleSpace: const FlexibleSpaceBar(
              background: FlutterLogo(),
              titlePadding: EdgeInsets.all(50),
              title: Text("Subscriptions")),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.only(left: padding + 5, bottom: 5),
            alignment: Alignment.bottomLeft,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: 300, height: 40),
              child: TextField(
                autofocus: false,
                maxLines: 1,
                onSubmitted: (value) => context.push("/search/$value"),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  hintText: 'Search',
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).cardColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).cardColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
          builder: (context, state) {
            switch (state.status) {
              case SubscriptionsStatus.failure:
                return const SliverToBoxAdapter(
                    child: Center(child: Text('failed to fetch posts')));
              case SubscriptionsStatus.success:
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
                        return PostCard(data: state.posts[index]);
                      }, childCount: state.posts.length),
                    ));
              case SubscriptionsStatus.initial:
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
        BlocListener<SortBloc, SortState>(
          listener: (context, state) {
            context
                .read<SubscriptionsBloc>()
                .add(SubscriptionsSortChanged(sortState: state.status));
            context
                .read<SubscriptionsBloc>()
                .add(DaysSortChanged(sortDays: state.sortDays));
          },
          child: const SliverToBoxAdapter(child: SizedBox()),
        )
      ]),
    );
  }
}
