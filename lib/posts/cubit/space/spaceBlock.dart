import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/posts/cubit/space/spaceEvent.dart';
import 'package:frontend/posts/cubit/space/spaceState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/appUser.dart';
import '../../../models/space.dart';
import '../../../stores/store.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class Pair {
  final int spaceId;
  final List<PostCardData> data;
  Pair(this.spaceId, this.data);
}

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc({required this.httpClient}) : super(const SpaceState()) {
    on<SpaceFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SpaceSortChanged>(
      _onSortChange,
      transformer: throttleDroppable(throttleDuration),
    );
    on<DaysSortChanged>(
      _onDaysChange,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onDaysChange(
    DaysSortChanged event,
    Emitter<SpaceState> emit,
  ) async {
    try {
      final posts = await getPosts(state.parentId, state.spaceName,
          sort: state.sortState, days: event.sortDays);
      return emit(
        state.copyWith(
          days: event.sortDays,
          status: SpaceStatus.success,
          posts: posts.data,
          spaceId: posts.spaceId,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SpaceStatus.failure));
    }
  }

  Future<void> _onSortChange(
    SpaceSortChanged event,
    Emitter<SpaceState> emit,
  ) async {
    try {
      final posts = await getPosts(state.parentId, state.spaceName,
          sort: event.sortState);
      return emit(
        state.copyWith(
          sortState: event.sortState,
          status: SpaceStatus.success,
          posts: posts.data,
          spaceId: posts.spaceId,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SpaceStatus.failure));
    }
  }

  Future<void> _onPostFetched(
    SpaceFetched event,
    Emitter<SpaceState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await getPosts(event.parentId, event.spaceName);
      return emit(
        state.copyWith(
          status: SpaceStatus.success,
          posts: posts.data,
          spaceId: posts.spaceId,
          parentId: event.parentId,
          spaceName: event.spaceName,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SpaceStatus.failure));
    }
  }

  Future<Pair> getPosts(int parentId, String? spaceName,
      {SortState sort = SortState.latest,
      SortDays days = SortDays.week}) async {
    final token = await Store.secure.read(key: 'jwt');
    var intDays = 7;
    switch (days) {
      case SortDays.month:
        intDays = 30;
      case SortDays.halfYear:
        intDays = 180;
      case SortDays.year:
        intDays = 365;
      case SortDays.week:
        intDays = 7;
    }
    final spaceInfo = await http.get(
      Uri.parse('${Config.baseUrl}/spaces?name=$spaceName&parentId=$parentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final space = Space.fromJson(jsonDecode(utf8.decode(spaceInfo.bodyBytes)));
    final spaceId = space.id;
    final res = await http.get(
      Uri.parse(
          '${Config.baseUrl}/posts/spaces/$spaceId?sort=${sort.name}&days=$intDays&userId=${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return Pair(spaceId, List.empty());
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<PostCardData>.empty(growable: true);
      for (final json in list) {
        output.add(PostCardData(
            post: Post.fromJson(json),
            spaceName: space.name,
            parentSpaceId: space.parentId));
      }
      return Pair(spaceId, output);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
