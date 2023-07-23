import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsEvent.dart';
import 'package:frontend/posts/cubit/subscriptions/subscriptionsState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/appUser.dart';
import '../../../models/space.dart';
import '../../../stores/store.dart';
import '../space/spaceState.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  SubscriptionsBloc({required this.httpClient})
      : super(const SubscriptionsState()) {
    on<SubscriptionsFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SubscriptionsSortChanged>(
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
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      final posts = await getPosts(sort: state.sortState, days: event.sortDays);
      return emit(
        state.copyWith(
          days: event.sortDays,
          status: SubscriptionsStatus.success,
          posts: posts,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SubscriptionsStatus.failure));
    }
  }

  Future<void> _onSortChange(
    SubscriptionsSortChanged event,
    Emitter<SubscriptionsState> emit,
  ) async {
    try {
      final posts = await getPosts(sort: event.sortState);
      return emit(
        state.copyWith(
          sortState: event.sortState,
          status: SubscriptionsStatus.success,
          posts: posts,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SubscriptionsStatus.failure));
    }
  }

  Future<void> _onPostFetched(
    SubscriptionsFetched event,
    Emitter<SubscriptionsState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await getPosts();
      return emit(
        state.copyWith(
          status: SubscriptionsStatus.success,
          posts: posts,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SubscriptionsStatus.failure));
    }
  }

  Future<List<PostCardData>> getPosts(
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
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final res = await http.get(
      Uri.parse(
          '${Config.baseUrl}/posts/users/${user.id}/subscriptions?sort=${sort.name}&days=$intDays'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return List.empty();
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<PostCardData>.empty(growable: true);
      for (final json in list) {
        output.add(PostCardData(
            post: Post.fromJson(json),
            spaceName: "Subscriptions",
            parentSpaceId: 1));
      }
      return output;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
