import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/search/searchBloc.dart';
import 'package:frontend/search/searchWidget.dart';
import 'package:http/http.dart' as http;

import '../cubit/search/searchEvent.dart';
import '../cubit/sorting/sortBloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.isTag, required this.term});
  final bool isTag;
  final String term;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchBloc(httpClient: http.Client())
            ..add(SearchFetched(term: term, isTag: isTag)),
        ),
      ],
      child: SearchWidget(),
    );
  }
}
