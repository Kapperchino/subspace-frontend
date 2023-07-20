import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/posts/cubit/search/searchBloc.dart';
import 'package:frontend/posts/cubit/search/searchState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/search/searchResult.dart';
import 'package:go_router/go_router.dart';

import '../posts/cubit/space/spaceBlock.dart';
import '../posts/cubit/space/spaceState.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController controllerSearch = TextEditingController();
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
          expandedHeight: 200.0,
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: const FlexibleSpaceBar(
            title: Text("Search"),
            background: FlutterLogo(),
            titlePadding: EdgeInsets.all(50),
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.failure:
                return const SliverToBoxAdapter(
                    child: Center(child: Text('failed to fetch posts')));
              case SearchStatus.success:
                if (state.spaces!.isEmpty) {
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('no posts')));
                }
                return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (index >= state.spaces!.length) {
                          return const SliverToBoxAdapter(
                              child: BottomLoader());
                        }
                        return SearchResult(
                          space: state.spaces![index],
                        );
                      }, childCount: state.spaces!.length),
                    ));
              case SearchStatus.initial:
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ]),
    );
  }
}
