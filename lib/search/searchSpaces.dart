import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/cubit/search/searchBloc.dart';
import 'package:frontend/cubit/search/searchState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/search/searchResult.dart';


class SearchSpaces extends StatelessWidget {
  const SearchSpaces({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 8.0);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStatus.failure:
            return const SliverToBoxAdapter(
                child: Center(child: Text('failed to fetch posts')));
          case SearchStatus.success:
            if (state.posts!.isEmpty) {
              return const SliverToBoxAdapter(
                  child: Center(child: Text('no posts')));
            }
            return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index >= state.spaces!.length) {
                      return const BottomLoader();
                    }
                    return SearchResult(
                      space: state.spaces![index],
                    );
                  }, childCount: state.spaces!.length),
                ));
          case SearchStatus.initial:
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator.adaptive()));
        }
      },
    );
  }
}
