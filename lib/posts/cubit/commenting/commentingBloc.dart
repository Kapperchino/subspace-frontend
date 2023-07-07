import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/posts/cubit/commenting/commentingEvent.dart';
import 'package:frontend/posts/cubit/commenting/commentingState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/appUser.dart';
import '../../../models/commentRequest.dart';
import '../../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CommentingBloc extends Bloc<CommentingEvent, CommentingState> {
  CommentingBloc({required this.httpClient}) : super(const CommentingState()) {
    on<CommentPressed>(
      onCommentSubmitted,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> onCommentSubmitted(
    CommentPressed event,
    Emitter<CommentingState> emit,
  ) async {
    if (state.status == CommentingStaus.closed ||
        state.status == CommentingStaus.success) {
      return emit(
        state.copyWith(
          status: CommentingStaus.started,
        ),
      );
    }
    if (state.status == CommentingStaus.failure) {
      if (event.comment.isEmpty) {
        return emit(state.copyWith(
          status: CommentingStaus.closed,
        ));
      }
    }
    if (state.status == CommentingStaus.started ||
        state.status == CommentingStaus.failure) {
      if (event.comment.isEmpty) {
        return emit(state.copyWith(
          status: CommentingStaus.closed,
        ));
      }
      final int res =
          await postComment(event.comment, event.postId, event.parentId);
      if (res != 200) {
        return emit(state.copyWith(
          status: CommentingStaus.failure,
        ));
      }
      return emit(
        state.copyWith(status: CommentingStaus.success),
      );
    }
  }
}

Future<int> postComment(String comment, int postId, int parentId) async {
  final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
  final token = await Store.secure.read(key: 'jwt');
  final res = await http.post(
    Uri.parse('${Config.baseUrl}/comments'),
    body: jsonEncode(CommentRequest(
      postId: postId,
      parentId: parentId,
      posterId: user.id,
      body: comment,
    ).toJson()),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );
  return res.statusCode;
}
