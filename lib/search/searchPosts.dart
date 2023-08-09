import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/posts/cubit/search/searchBloc.dart';
import 'package:frontend/posts/cubit/search/searchState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/search/searchResult.dart';

import '../posts/postCardWrapper.dart';

class SearchPosts extends StatelessWidget {
  const SearchPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 0.0);

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
                    if (index >= state.posts!.length) {
                      return const BottomLoader();
                    }
                    return PostCardWrapper(
                      spaceName: "",
                      data: PostCardData(
                          parentSpaceId: state.posts![index].spaceParentId,
                          spaceName: state.posts![index].spaceName,
                          post: state.posts![index]),
                    );
                  }, childCount: state.posts!.length),
                ));
          case SearchStatus.initial:
            return const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
