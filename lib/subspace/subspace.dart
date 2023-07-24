import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/posts/cubit/sorting/sortBloc.dart';
import 'package:frontend/posts/cubit/sorting/sortState.dart';
import 'package:frontend/posts/cubit/space/spaceEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/title/titleBloc.dart';
import 'package:frontend/posts/cubit/title/titleEvent.dart';
import 'package:frontend/subspace/sortPostsDaysWidget.dart';
import 'package:frontend/subspace/sortPostsWidget.dart';
import 'package:frontend/subspace/titleWidget.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../posts/cubit/space/spaceBlock.dart';
import '../posts/cubit/space/spaceState.dart';
import '../posts/postcard.dart';

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
            BlocBuilder<SpaceBloc, SpaceState>(
                builder: (context, state) => ListTile(
                      title: const Text('Create Subspace'),
                      onTap: () {
                        context.push("/create/space/${state.spaceId}");
                      },
                    )),
            BlocBuilder<SpaceBloc, SpaceState>(
                builder: (context, state) => ListTile(
                      title: const Text('Subscriptions'),
                      onTap: () {
                        context.push("/subscriptions");
                      },
                    )),
          ],
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          snap: false,
          floating: false,
          expandedHeight: 200.0,
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
                  Container(
                    padding: EdgeInsets.only(right: padding, bottom: 10),
                    alignment: Alignment.bottomRight,
                    child: BlocBuilder<SpaceBloc, SpaceState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () async {
                            context
                                .push("/create/space/${state.spaceId}/post")
                                .then((value) => context.read<SpaceBloc>().add(
                                    SpaceFetched(
                                        parentId: parentId, spaceName: name)));
                          },
                          child: const Text('Post'),
                        );
                      },
                    ),
                  ),
                ],
              )),
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: FlexibleSpaceBar(
            background: const FlutterLogo(),
            titlePadding: const EdgeInsets.all(50),
            title: TitleWidget(
              title: name,
            ),
          ),
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
        BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            switch (state.status) {
              case SpaceStatus.failure:
                return const SliverToBoxAdapter(
                    child: Center(child: Text('failed to fetch posts')));
              case SpaceStatus.success:
                if (name != "SubSpace") {
                  context.read<TitleBloc>().add(
                      InitEvent(context.read<SpaceBloc>().state.spaceId, name));
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
                        return PostCard(data: state.posts[index]);
                      }, childCount: state.posts.length),
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
          listenWhen: (previous, current) {
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
    );
  }
}
