import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/posts/cubit/posting/postingBloc.dart';
import 'package:frontend/posts/cubit/posting/postingEvent.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:frontend/posts/cubit/space/spaceEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/subspace/postingWidget.dart';
import 'package:frontend/subspace/sortPostsDaysWidget.dart';
import 'package:frontend/subspace/sortPostsWidget.dart';

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

  final TextEditingController controllerTopic = TextEditingController();
  final TextEditingController controllerBody = TextEditingController();
  final TextEditingController controllerLink = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          snap: false,
          floating: false,
          expandedHeight: 160.0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: padding, bottom: 10),
                        alignment: Alignment.bottomLeft,
                        child: BlocBuilder<SpaceBloc, SpaceState>(
                          builder: (context, state) {
                            return const SortPostsWidget();
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: padding, bottom: 10),
                        alignment: Alignment.bottomLeft,
                        child: BlocBuilder<SpaceBloc, SpaceState>(
                          builder: (context, state) {
                            return const SortPostsDaysWidget();
                          },
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
                            context.read<PostingBloc>().add(PostPressed(
                                body: controllerBody.text,
                                topic: controllerTopic.text,
                                content: controllerLink.text,
                                spaceId: state.spaceId));
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
            title: Text(name),
            background: const FlutterLogo(),
            titlePadding: const EdgeInsets.all(50),
          ),
        ),
        SliverToBoxAdapter(
            child: PostingWidget(
          controllerBody: controllerBody,
          controllerTopic: controllerTopic,
          controllerLink: controllerLink,
        )),
        BlocListener<PostingBloc, PostingState>(
          listener: (context, state) {
            ScaffoldMessenger.of(context).clearSnackBars();
            if (state.status == PostingStatus.success) {
              controllerBody.clear();
              controllerTopic.clear();
              controllerLink.clear();
              BlocProvider.of<SpaceBloc>(context)
                  .add(SpaceFetched(parentId: parentId, spaceName: name));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Post created')));
            } else if (state.status == PostingStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red, content: Text('Error input')));
            }
          },
          child: const SliverToBoxAdapter(child: SizedBox()),
        ),
        BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            switch (state.status) {
              case SpaceStatus.failure:
                return const SliverToBoxAdapter(
                    child: Center(child: Text('failed to fetch posts')));
              case SpaceStatus.success:
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
      ]),
    );
  }
}
