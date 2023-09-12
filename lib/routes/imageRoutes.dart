import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/imageView/imageViewEvent.dart';
import 'package:frontend/posts/imageView.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../cubit/imageView/imageViewBloc.dart';
import '../stores/store.dart';

class ImageRoutes {
  GoRoute getImageRoute() {
    return GoRoute(
        path: '/images/:id',
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
          final id = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (_) => ImageViewBloc(httpClient: http.Client())
              ..add(ImageFetched(imageId: id)),
            child: ImageView(),
          );
        });
  }
}
