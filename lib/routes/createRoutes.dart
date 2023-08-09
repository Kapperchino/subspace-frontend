import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/spaceCreation/spaceCreationBloc.dart';
import 'package:frontend/subspace/postingWidget.dart';
import 'package:frontend/subspace/subspaceCreationWidget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../posts/cubit/posting/postingBloc.dart';
import '../stores/store.dart';
import 'package:http/http.dart' as http;

class CreateRoutes {
  GoRoute getPostCreationRoute() {
    return GoRoute(
        path: '/create/space/:id/post',
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
          final spaceId = int.parse(state.pathParameters['id']!);
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
                create: (_) => PostingBloc(httpClient: http.Client()),
                child: PostingWidget(
                  spaceId: spaceId,
                ),
              ));
        });
  }

  GoRoute getSpaceCreationRoute() {
    return GoRoute(
        path: '/create/space/:parentId',
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
          final parentId = int.parse(state.pathParameters['parentId']!);
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
                create: (_) => SpaceCreationBloc(
                    httpClient: http.Client(), parentId: parentId),
                child: SubspaceCreationWidget(
                  parentId: parentId,
                ),
              ));
        });
  }
}
