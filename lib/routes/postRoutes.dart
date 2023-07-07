
import 'package:flutter/material.dart';
import 'package:frontend/posts/postPage.dart';
import 'package:go_router/go_router.dart';

import '../stores/store.dart';

class PostRoutes {
  GoRoute getPostRoute() {
    return GoRoute(
        path: 'p/:id',
        redirect: (context, state) async {
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return '/login';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'];
          final subspaceName = state.pathParameters['subSpace']!;
          return PostPage(
            id: int.parse(id!),
            spaceName: subspaceName,
          );
        });
  }


}
