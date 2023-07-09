import 'dart:async';
import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/posts/cubit/posting/postingEvent.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:stream_transform/stream_transform.dart';
import 'dart:html' as html;

import '../../../config.dart';
import '../../../models/appUser.dart';
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
    on<ModeChanged>((event, emit) => onModeChange(event, emit));
  }

  final http.Client httpClient;

  void onModeChange(
    ModeChanged event,
    Emitter<PostingState> emit,
  ) {
    return emit(state.copyWith(mode: event.mode));
  }

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
      if (event.body.length >= 60000 || event.topic.length >= 6000) {
        return emit(state.copyWith(
          status: PostingStatus.failure,
        ));
      }
      if (state.mode == PostingMode.link) {
        final type = await getContentType(event.content);
        final int res = await postPost(event.body, event.topic, event.spaceId,
            content: event.content, contentType: type);
        if (res != 200) {
          return emit(state.copyWith(
            status: PostingStatus.failure,
          ));
        }
        return emit(
          state.copyWith(status: PostingStatus.success),
        );
      } else if (state.mode == PostingMode.text) {
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

  Future<ContentType> getContentType(String url) async {
    try {
      final mime = lookupMimeType(url);
      if (mime == null) {
        return ContentType.link;
      }
      if (mime.contains("image")) {
        return ContentType.picture;
      }
      if (mime.contains("video")) {
        return ContentType.video;
      }
      return ContentType.link;
    } catch (e) {
      emit(state.copyWith(
        status: PostingStatus.failure,
      ));
    }
    return ContentType.unknown;
  }

  Future<int> postPost(String body, String topic, int spaceId,
      {String content = "", ContentType contentType = ContentType.text}) async {
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/posts'),
      body: jsonEncode(PostRequest(
        content: content,
        type: contentType,
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
}
