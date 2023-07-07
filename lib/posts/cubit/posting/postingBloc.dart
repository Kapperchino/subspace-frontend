import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/CommentData.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/comment/commentState.dart';
import 'package:frontend/posts/cubit/posting/postingEvent.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/appUser.dart';
import '../../../models/comment.dart';
import '../../../models/post.dart';
import '../../../models/postRequest.dart';
import '../../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostingBloc extends Bloc<PostingEvent, PostingState> {
  PostingBloc({required this.httpClient}) : super(const PostingState()) {
    on<PostPressed>(
      onPostSubmitted,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> onPostSubmitted(
    PostPressed event,
    Emitter<PostingState> emit,
  ) async {
    if (state.status == PostingStatus.closed ||
        state.status == PostingStatus.success) {
      return emit(
        state.copyWith(
          status: PostingStatus.started,
        ),
      );
    }
    if (state.status == PostingStatus.failure) {
      if (event.body.isEmpty || event.topic.isEmpty) {
        return emit(state.copyWith(
          status: PostingStatus.closed,
        ));
      }
    }
    if (state.status == PostingStatus.started ||
        state.status == PostingStatus.failure) {
      if (event.body.isEmpty && event.topic.isEmpty) {
        return emit(state.copyWith(
          status: PostingStatus.closed,
        ));
      }
      if (event.body.isEmpty || event.topic.isEmpty) {
        return emit(state.copyWith(
          status: PostingStatus.failure,
        ));
      }
      final int res = await postPost(event.body, event.topic, event.spaceId);
      if (res != 200) {
        return emit(state.copyWith(
          status: PostingStatus.failure,
        ));
      }
      return emit(
        state.copyWith(status: PostingStatus.success),
      );
    }
  }
}

Future<int> postPost(String body, String topic, int spaceId,
    {String content = "", ContentType contentType = ContentType.text}) async {
  final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
  final token = await Store.secure.read(key: 'jwt');
  final res = await http.post(
    Uri.parse('${Config.baseUrl}/posts'),
    body: jsonEncode(PostRequest(
      content: content,
      topic: topic,
      spaceId: spaceId,
      posterId: user.id,
      body: body,
    ).toJson()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );
  return res.statusCode;
}
