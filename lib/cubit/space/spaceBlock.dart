import 'dart:async';
import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/cubit/space/spaceEvent.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../models/space.dart';
import '../../stores/store.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SpaceBloc extends HydratedBloc<SpaceEvent, SpaceState> {
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
          posts: posts.$2,
          spaceId: posts.$1.id,
          spaceMeta: posts.$1,
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
          sort: event.sortState, days: state.sortDays);
      return emit(
        state.copyWith(
          sortState: event.sortState,
          status: SpaceStatus.success,
          posts: posts.$2,
          spaceId: posts.$1.id,
          spaceMeta: posts.$1,
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
      final posts = await getPosts(event.parentId, event.spaceName,
          sort: state.sortState, days: state.sortDays);
      return emit(
        state.copyWith(
          status: SpaceStatus.success,
          posts: posts.$2,
          spaceId: posts.$1.id,
          spaceMeta: posts.$1,
          parentId: event.parentId,
          spaceName: event.spaceName,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      return emit(state.copyWith(status: SpaceStatus.failure));
    }
  }

  Future<(Space, List<PostCardData>, PictureMeta?)> getPosts(
      int parentId, String? spaceName,
      {SortStatus sort = SortStatus.latest,
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
    final AppUser? user = await UserUtil.getAppUser();
    final space = Space.fromJson(jsonDecode(utf8.decode(spaceInfo.bodyBytes)));
    final spaceId = space.id;
    final image = space.backgroundPicture;
    final res = await http.get(
      Uri.parse(
          '${Config.baseUrl}/posts/spaces/$spaceId?sort=${sort.name}&days=$intDays&userId=${user!.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        List<PostCardData> list = List.empty();
        return (space, list, image);
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<PostCardData>.empty(growable: true);
      for (final json in list) {
        output.add(PostCardData(
          spaceName: spaceName!,
          post: Post.fromJson(json),
        ));
      }
      return (space, output, image);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  @override
  SpaceState? fromJson(Map<String, dynamic> json) {
    var res = SpaceState.fromJson(json);
    if (res.status != SpaceStatus.success) {
      return null;
    }
    return res;
  }

  @override
  Map<String, dynamic>? toJson(SpaceState state) {
    if (state.status != SpaceStatus.success) {
      return null;
    }
    return state.toJson();
  }
}
