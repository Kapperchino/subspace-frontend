import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/search/searchBloc.dart';
import 'package:frontend/posts/cubit/search/searchEvent.dart';
import 'package:frontend/search/searchPage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../stores/store.dart';
import 'package:http/http.dart' as http;

class SearchRoutes {
  GoRoute getSearchRoute() {
    return GoRoute(
        path: '/search/:term',
        redirect: (context, state) async {
          String? expire = GetStorage().read("expire");
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return "/login";
          }
          if (expire != null) {
            final time = DateTime.parse(expire);
            if (time.isBefore(DateTime.now())) {
              return "/login";
            }
            return null;
          }
          return "/login";
        },
        pageBuilder: (BuildContext context, GoRouterState state) {
          var term = state.pathParameters['term']!;
          bool isTag = state.queryParameters['isTag']! == 'true';
          return CustomTransitionPage<void>(
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                late final Animation<double> _animation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutSine,
                );
                return ScaleTransition(scale: _animation, child: child);
              },
              child: BlocProvider(
                create: (_) => SearchBloc(httpClient: http.Client())
                  ..add(SearchFetched(term: term, isTag: isTag)),
                child: SearchPage(),
              ));
        });
  }
}
