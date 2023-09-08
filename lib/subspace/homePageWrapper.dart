import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/posting/postingBloc.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsEvent.dart';
import 'package:frontend/subspace/homePage.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import '../cubit/space/spaceBlock.dart';
import '../cubit/space/spaceEvent.dart';
import '../cubit/title/titleBloc.dart';

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SubscriptionsBloc(httpClient: http.Client())
            ..add(SubscriptionsFetched()),
        ),
        BlocProvider(
          create: (_) => SpaceBloc(httpClient: http.Client())
            ..add(SpaceFetched(parentId: 1, spaceName: "SubSpace")),
        ),
        BlocProvider(create: (_) => PostingBloc(httpClient: http.Client())),
        BlocProvider(
          create: (_) => TitleBloc(httpClient: http.Client()),
        ),
        BlocProvider(create: (_) => SortBloc(httpClient: http.Client()))
      ],
      child: HomePage(),
    );
  }
}
