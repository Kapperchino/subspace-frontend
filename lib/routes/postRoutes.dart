import 'package:flutter/material.dart';
import 'package:frontend/posts/postPage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../stores/store.dart';

class PostRoutes {
  GoRoute getPostRoute() {
    return GoRoute(
        path: 'p/:id',
        redirect: (context, state) async {
          String? expire = GetStorage().read("expire");
          if (expire != null) {
            final time = DateTime.parse(expire);
            if (time.isBefore(DateTime.now())) {
              return "/login";
            }
            return null;
          }
          return "/login";
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
