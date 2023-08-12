import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/search/searchEvent.dart';
import 'package:frontend/cubit/search/searchState.dart';
import 'package:get_storage/get_storage.dart';
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
  }

  final http.Client httpClient;

  Future<void> _onSearchFetched(
    SearchFetched event,
    Emitter<SearchState> emit,
  ) async {
    try {
      List<Space> spaces = List.empty(growable: true);
      if (!event.isTag) {
        spaces = await searchSpaces(event.term);
      }
      final posts = await searchPosts(event.term, event.isTag);
      return emit(SearchState(
          spaces: spaces, posts: posts, status: SearchStatus.success));
    } catch (_) {
      emit(const SearchState(status: SearchStatus.failure));
    }
  }

  Future<List<Space>> searchSpaces(String term) async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/search/spaces?term=$term'),
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

  Future<List<Post>> searchPosts(String term, bool isTag) async {
    final token = await Store.secure.read(key: 'jwt');
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final res = await http.get(
      Uri.parse(
          '${Config.baseUrl}/search/posts?term=$term&userId=${user.id}&isTag=$isTag'),
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
      var output = List<Post>.empty(growable: true);
      for (final json in list) {
        output.add(Post.fromJson(json));
      }
      return output;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
