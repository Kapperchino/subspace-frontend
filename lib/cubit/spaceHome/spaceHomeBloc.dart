import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/spaceHome/spaceHomeEvent.dart';
import 'package:frontend/cubit/spaceHome/spaceHomeState.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/space.dart';
import '../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SpaceHomeBloc extends Bloc<SpaceHomeEvent, SpaceHomeState> {
  SpaceHomeBloc({required this.httpClient}) : super(const SpaceHomeState()) {
    on<SpacesFetched>(
      _onSearchFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onSearchFetched(
    SpacesFetched event,
    Emitter<SpaceHomeState> emit,
  ) async {
    try {
      List<Space> popularSpaces = List.empty(growable: true);
      popularSpaces = await searchSpaces("popular");
      List<Space> latestSpaces = List.empty(growable: true);
      latestSpaces = await searchSpaces("latest");
      return emit(state.copyWith(
          status: SpaceHomeStatus.success,
          latestSpaces: latestSpaces,
          popularSpaces: popularSpaces));
    } catch (_) {
      return emit(state.copyWith(
        status: SpaceHomeStatus.failure,
      ));
    }
  }

  Future<List<Space>> searchSpaces(
    String sort,
  ) async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/spaces/sort?sortBy=$sort'),
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
      final spaces = list.map((e) => Space.fromJson(e));
      return spaces.toList();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
