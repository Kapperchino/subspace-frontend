import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/posting/postingBloc.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsEvent.dart';
import 'package:frontend/subspace/subscriptionsWidget.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import '../posts/cubit/sorting/sortBloc.dart';
import '../posts/cubit/space/spaceBlock.dart';
import '../posts/cubit/space/spaceEvent.dart';
import '../posts/cubit/title/titleBloc.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SubscriptionsBloc(httpClient: http.Client())
            ..add(SubscriptionsFetched()),
        ),
        BlocProvider(create: (_) => PostingBloc(httpClient: http.Client())),
        BlocProvider(create: (_) => SortBloc(httpClient: http.Client()))
      ],
      child: const SubscriptionsWidget(),
    );
  }
}
