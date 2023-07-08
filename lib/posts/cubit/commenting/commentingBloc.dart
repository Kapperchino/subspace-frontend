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
  CommentingBloc(
      {required this.httpClient,
      required this.postId,
      required this.parentId,
      this.isPostComment = true})
      : super(const CommentingState()) {
    on<CommentPressed>(
      onCommentSubmitted,
      transformer: throttleDroppable(throttleDuration),
    );
    on<CommentChanged>(
      onCommentChanged,
    );
  }

  final http.Client httpClient;
  final int postId;
  final int parentId;
  final bool isPostComment;

  Future<void> onCommentChanged(
    CommentChanged event,
    Emitter<CommentingState> emit,
  ) async {
    return emit(
      state.copyWith(comment: event.comment),
    );
  }

  Future<void> onCommentSubmitted(
    CommentPressed event,
    Emitter<CommentingState> emit,
  ) async {
    if (state.status == CommentingStaus.closed ||
        state.status == CommentingStaus.success) {
      return emit(
        state.copyWith(status: CommentingStaus.started),
      );
    }
    if (state.status == CommentingStaus.failure) {
      if (state.comment.isEmpty) {
        return emit(state.copyWith(status: CommentingStaus.closed));
      }
    }
    if (state.status == CommentingStaus.started ||
        state.status == CommentingStaus.failure) {
      if (state.comment.isEmpty) {
        return emit(state.copyWith(status: CommentingStaus.closed));
      }
      if (state.comment.length >= 40000) {
        return emit(state.copyWith(status: CommentingStaus.failure));
      }
      final int res =
          await postComment(state.comment, event.postId, event.parentId);
      if (res != 200) {
        return emit(state.copyWith(
            status: CommentingStaus.failure, comment: state.comment));
      }
      return emit(
        state.copyWith(status: CommentingStaus.success, comment: ""),
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
