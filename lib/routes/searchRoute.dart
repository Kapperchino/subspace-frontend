import 'package:flutter/material.dart';
import 'package:frontend/search/searchHome.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../search/searchPage.dart';
import '../stores/store.dart';

class SearchRoutes {
  GoRoute getSearchRoute() {
    return GoRoute(
        path: '/search/results/:term',
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
          bool isTag = state.uri.queryParameters['isTag']! == 'true';
          return CustomTransitionPage<void>(
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                late final Animation<double> _animation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutSine,
                );
                return ScaleTransition(scale: _animation, child: child);
              },
              child: SearchPage(term: term, isTag: isTag));
        });
  }

  GoRoute getSearchRouteHome() {
    return GoRoute(
      path: '/search/home',
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
      builder: (context, state) {
        return SearchHome();
      },
    );
  }
}
