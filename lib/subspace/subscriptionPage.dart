import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/posting/postingBloc.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsBloc.dart';
import 'package:frontend/cubit/subscriptions/subscriptionsEvent.dart';
import 'package:frontend/subspace/subscriptionsWidget.dart';
import 'package:http/http.dart' as http;

import '../cubit/sorting/sortBloc.dart';

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
