import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/trending/trendingEvent.dart';
import 'package:frontend/cubit/trending/trendingState.dart';
import 'package:frontend/models/tagMeta.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  TrendingBloc({required this.httpClient}) : super(const TrendingState()) {
    on<HashTagsFetched>(
      _onTagsFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onTagsFetched(
    HashTagsFetched event,
    Emitter<TrendingState> emit,
  ) async {
    try {
      final tags = await getTags();
      return emit(state.copyWith(
        status: TrendingStatus.success,
        tags: tags,
      ));
    } catch (_) {
      return emit(state.copyWith(
        status: TrendingStatus.failure,
      ));
    }
  }

  Future<List<TagMeta>> getTags() async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/tags'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      if (res.body == 'null' || res.body.isEmpty) {
        return List.empty();
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      final tags = list.map((e) => TagMeta.fromJson(e));
      return tags.toList();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
