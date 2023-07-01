import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/subspace/postCreationWidget.dart';

import '../posts/postcard.dart';

class Subspace extends StatefulWidget {
  const Subspace(
      {super.key,
      required this.name,
      required this.discription,
      required this.users,
      required this.items});

  final String name;
  final String discription;
  final int users;
  final List<PostCard> items;

  @override
  State<StatefulWidget> createState() {
    return _SubSpaceState(
        name: name, discription: discription, users: users, items: items);
  }
}

class _SubSpaceState extends State<Subspace> {
  _SubSpaceState(
      {required this.name,
      required this.discription,
      required this.users,
      required this.items});

  final String name;
  final String discription;
  final int users;
  final List<PostCard> items;
  bool started = false;

  onClick() {
    started = !started;
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
              child: Padding(
                padding: EdgeInsets.only(right: padding, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => {setState(() => onClick())},
                    child: const Text('Post'),
                  ),
                ),
              )),
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(name),
            background: const FlutterLogo(),
            titlePadding: const EdgeInsets.all(50),
          ),
        ),
        SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: started ? 150 : 0,
            curve: Curves.easeInOutCubicEmphasized,
            child: const PostCreationWidget(),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: items[index],
            );
          }, childCount: items.length),
        )
      ]),
    );
  }
}
