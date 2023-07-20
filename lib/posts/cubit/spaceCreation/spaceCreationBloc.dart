import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/spaceCreationRequest.dart';
import 'package:frontend/posts/cubit/spaceCreation/spaceCreationEvent.dart';
import 'package:frontend/posts/cubit/spaceCreation/spaceCreationState.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SpaceCreationBloc extends Bloc<SpaceCreationEvent, SpaceCreationState> {
  SpaceCreationBloc({required this.httpClient})
      : super(const SpaceCreationState()) {
    on<SpaceCreated>(
      onSpaceCreated,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> onSpaceCreated(
    SpaceCreated event,
    Emitter<SpaceCreationState> emit,
  ) async {
    final res = await createSpace(
        event.name, event.discription, state.parentId, event.picture);
    if (res == 200) {
      emit(state.copyWith(status: SpaceCreationStatus.success));
    } else {
      emit(state.copyWith(status: SpaceCreationStatus.failure));
    }
  }

  Future<int> createSpace(
      String name, String discription, int parentId, String picture) async {
    final token = await Store.secure.read(key: 'jwt');
    final json = jsonEncode(SpaceCreationRequest(
            parentId: state.parentId,
            name: name,
            description: discription,
            picture: picture)
        .toJson());
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/spaces'),
      body: json,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }
}
