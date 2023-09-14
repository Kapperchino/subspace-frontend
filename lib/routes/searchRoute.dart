import 'package:flutter/material.dart';
import 'package:frontend/search/searchHomeWrapper.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:go_router/go_router.dart';

import '../search/searchPage.dart';
import '../stores/store.dart';

class SearchRoutes {
  GoRoute getSearchRoute() {
    return GoRoute(
        path: '/search/results/:term',
        redirect: (context, state) async {
          DateTime? expire = await UserUtil.getExpire();
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return "/login";
          }
          if (expire != null) {
            if (expire.isBefore(DateTime.now())) {
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
                late final Animation<double> curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutSine,
                );
                return ScaleTransition(scale: curvedAnimation, child: child);
              },
              child: SearchPage(term: term, isTag: isTag));
        });
  }

  GoRoute getSearchRouteHome() {
    return GoRoute(
      path: '/search/home',
      redirect: (context, state) async {
        DateTime? expire = await UserUtil.getExpire();
        final jwt = await Store.secure.read(key: "jwt");
        if (jwt == null) {
          return "/login";
        }
        if (expire != null) {
          if (expire.isBefore(DateTime.now())) {
            return "/login";
          }
          return null;
        }
        return "/login";
      },
      builder: (context, state) {
        return const SearchHomeWrapper();
      },
    );
  }
}
