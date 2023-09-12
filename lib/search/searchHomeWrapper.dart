import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/trending/trendingBloc.dart';
import 'package:frontend/cubit/trending/trendingEvent.dart';
import 'package:frontend/search/searchHome.dart';
import 'package:http/http.dart' as http;

class SearchHomeWrapper extends StatelessWidget {
  const SearchHomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TrendingBloc(httpClient: http.Client())..add(HashTagsFetched()),
      child: SearchHome(),
    );
  }
}
