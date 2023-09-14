import 'package:flutter/material.dart';
import 'package:frontend/routes/postRoutes.dart';
import 'package:frontend/subspace/homePageWrapper.dart';
import 'package:frontend/subspace/subspaceHomeWrapper.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:go_router/go_router.dart';

import '../stores/store.dart';
import '../subspace/spacePage.dart';

class SpaceRoutes {
  GoRoute getSpaceRoute() {
    return GoRoute(
        path: '/s/:parentSpace/:subSpace',
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
        routes: [PostRoutes().getPostRoute()],
        builder: (BuildContext context, GoRouterState state) {
          final spaceName = state.pathParameters['subSpace'];
          final parentId = int.parse(state.pathParameters['parentSpace']!);
          return SpacePage(
            spaceName: spaceName!,
            parentId: parentId,
          );
        }
        //TODO: add user count
        );
  }

  GoRoute getHome() {
    return GoRoute(
        path: '/home',
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
        builder: (BuildContext context, GoRouterState state) {
          return const HomePageWrapper();
        });
  }

  GoRoute getSpaceHome() {
    return GoRoute(
        path: '/s/home',
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
        routes: [PostRoutes().getPostRoute()],
        builder: (BuildContext context, GoRouterState state) {
          return const SubSpaceHomeWrapper();
        }
        //TODO: add user count
        );
  }
}
