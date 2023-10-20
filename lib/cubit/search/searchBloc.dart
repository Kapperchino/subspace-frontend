import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/search/searchEvent.dart';
import 'package:frontend/cubit/search/searchState.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/models/userMeta.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../models/post.dart';
import '../../models/space.dart';
import '../../stores/store.dart';

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
    on<SearchSortChanged>(_onSearchSortChanged,
        transformer: throttleDroppable(throttleDuration));
    on<SearchSortDaysChanged>(_onSearchSortDaysChanged,
        transformer: throttleDroppable(throttleDuration));
  }

  final http.Client httpClient;

  Future<void> _onSearchFetched(
    SearchFetched event,
    Emitter<SearchState> emit,
  ) async {
    try {
      List<Space> spaces = List.empty(growable: true);
      spaces = await searchSpaces(event.term);
      final posts = await searchPosts(event.term, event.isTag);
      final users = await searchUsers(event.term);
      return emit(state.copyWith(
          spaces: spaces,
          posts: posts,
          users: users,
          isTag: event.isTag,
          term: event.term,
          status: SearchStatus.success));
    } catch (_) {
      return emit(const SearchState(status: SearchStatus.failure));
    }
  }

  Future<void> _onSearchSortChanged(
    SearchSortChanged event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final posts = await searchPosts(state.term, state.isTag,
          sortStatus: event.status, days: state.sortDays);
      return emit(state.copyWith(
          posts: posts,
          status: SearchStatus.success,
          sortStatus: event.status));
    } catch (_) {
      return emit(const SearchState(status: SearchStatus.failure));
    }
  }

  Future<void> _onSearchSortDaysChanged(
    SearchSortDaysChanged event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final posts = await searchPosts(state.term, state.isTag,
          sortStatus: state.sortStatus, days: event.days);
      return emit(state.copyWith(
          posts: posts, status: SearchStatus.success, sortDays: event.days));
    } catch (_) {
      return emit(const SearchState(status: SearchStatus.failure));
    }
  }

  Future<List<Space>> searchSpaces(
    String term,
  ) async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/search/spaces?term=$term'),
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

  Future<List<PostCardData>> searchPosts(String term, bool isTag,
      {SortStatus sortStatus = SortStatus.popular,
      SortDays days = SortDays.week}) async {
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
    final token = await Store.secure.read(key: 'jwt');
    final AppUser? user = await UserUtil.getAppUser();
    final res = await http.get(
      Uri.parse(
          '${Config.baseUrl}/search/posts?term=$term&userId=${user!.id}&isTag=$isTag&sort=${sortStatus.name}&days=$intDays'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    ); // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return List.empty();
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<PostCardData>.empty(growable: true);
      for (final json in list) {
        var post = Post.fromJson(json);
        output.add(PostCardData(post: post));
      }
      return output;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<List<UserMeta>> searchUsers(String term) async {
    final token = await Store.secure.read(key: 'jwt');
    final AppUser? user = await UserUtil.getAppUser();
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/search/users?term=$term'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    ); // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return List.empty();
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<UserMeta>.empty(growable: true);
      for (final json in list) {
        output.add(UserMeta.fromJson(json));
      }
      return output;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
