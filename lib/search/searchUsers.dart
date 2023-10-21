import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/cubit/search/searchBloc.dart';
import 'package:frontend/cubit/search/searchState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/search/userResult.dart';

class SearchUsers extends StatelessWidget {
  const SearchUsers({super.key});

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
                  child: Center(child: Text('no users')));
            }
            return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index >= state.users!.length) {
                      return const BottomLoader();
                    }
                    return UserResult(
                      user: state.users![index],
                    );
                  }, childCount: state.users!.length),
                ));
          case SearchStatus.initial:
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator.adaptive()));
        }
      },
    );
  }
}
