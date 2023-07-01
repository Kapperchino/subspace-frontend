import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../posts/postcard.dart';

class Subspace extends StatelessWidget {
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
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(name),
            background: const FlutterLogo(),
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
