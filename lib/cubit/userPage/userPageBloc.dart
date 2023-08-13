import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:frontend/cubit/userPage/userPageEvent.dart';
import 'package:frontend/cubit/userPage/userPageState.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/cubit/space/spaceEvent.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../models/space.dart';
import '../../models/userMeta.dart';
import '../../stores/store.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  UserPageBloc({required this.httpClient})
      : super(UserPageState(controller: TextEditingController())) {
    on<UserPageFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageSortChanged>(
      _onSortChange,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageDaysSortChanged>(
      _onDaysChange,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageInit>(
      _onInit,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageBioToggle>(
      _onBioEdit,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onBioEdit(
    UserPageBioToggle event,
    Emitter<UserPageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.bioStatus != BioEditStatus.edit) {
      return emit(state.copyWith(bioStatus: BioEditStatus.edit));
    }
    if (state.controller.text != state.user!.bio) {
      final token = await Store.secure.read(key: 'jwt');
      final res = await httpClient.put(
          Uri.parse('${Config.baseUrl}/users/${state.user!.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"bio": state.controller.text}));
      if (res.statusCode == 200) {
        return emit(state.copyWith(bioStatus: BioEditStatus.success));
      }
      return emit(state.copyWith(bioStatus: BioEditStatus.failure));
    }
    return emit(state.copyWith(bioStatus: BioEditStatus.start));
  }

  Future<void> _onInit(
    UserPageInit event,
    Emitter<UserPageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await getPosts(event.userId);
      return emit(
        state.copyWith(
            status: UserPageStatus.success,
            posts: posts.$1,
            user: posts.$2,
            hasReachedMax: false,
            controller: TextEditingController(text: posts.$2.bio)),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<void> _onDaysChange(
    UserPageDaysSortChanged event,
    Emitter<UserPageState> emit,
  ) async {
    try {
      final posts = await getPosts(state.user!.id,
          sort: state.sortState, days: event.sortDays);
      return emit(
        state.copyWith(
          days: event.sortDays,
          status: UserPageStatus.success,
          posts: posts.$1,
          user: posts.$2,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<void> _onSortChange(
    UserPageSortChanged event,
    Emitter<UserPageState> emit,
  ) async {
    try {
      final posts = await getPosts(state.user!.id,
          sort: event.sortState, days: state.sortDays);
      return emit(
        state.copyWith(
          sortState: event.sortState,
          status: UserPageStatus.success,
          posts: posts.$1,
          user: posts.$2,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<void> _onPostFetched(
    UserPageFetched event,
    Emitter<UserPageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await getPosts(event.userId);
      return emit(
        state.copyWith(
          status: UserPageStatus.success,
          posts: posts.$1,
          user: posts.$2,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<(List<Post>, UserMeta)> getPosts(int userId,
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
    final userInfo = await http.get(
      Uri.parse('${Config.baseUrl}/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    final user = UserMeta.fromJson(jsonDecode(utf8.decode(userInfo.bodyBytes)));
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/posts/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        List<Post> list = List.empty();
        return (list, user);
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<Post>.empty(growable: true);
      for (final json in list) {
        output.add(Post.fromJson(json));
      }
      return (output, user);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
