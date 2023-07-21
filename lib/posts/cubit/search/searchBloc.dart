import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/posts/cubit/search/searchEvent.dart';
import 'package:frontend/posts/cubit/search/searchState.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/space.dart';
import '../../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.httpClient}) : super(const SearchState()) {
    on<SearchFetched>(
      _onSearchFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onSearchFetched(
    SearchFetched event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final spaces = await searchSpaces(event.term);
      return emit(SearchState(spaces: spaces, status: SearchStatus.success));
    } catch (_) {
      emit(const SearchState(status: SearchStatus.failure));
    }
  }

  Future<List<Space>> searchSpaces(String term) async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/search/$term'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      final spaces = list.map((e) => Space.fromJson(e));
      return spaces.toList();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
