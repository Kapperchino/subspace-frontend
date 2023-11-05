import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/cubit/post/postEvent.dart';
import 'package:frontend/cubit/post/postState.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:video_player/video_player.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../stores/store.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    try {
      final post = await getPost(event.postId);
      final state = PostState(status: PostStatus.success);
      if (post.type == ContentType.video) {
        final maxWidth = min(event.deviceWidth, 600);
        final imageRatio =
            post.postVideos![0].width / post.postVideos![0].height;
        final adjustedHeight = maxWidth / imageRatio;
        final double height = min(600, adjustedHeight);
        final ratio = min(post.postVideos![0].width / maxWidth,
            post.postVideos![0].height / height);
        state.controller ??= VideoPlayerController.networkUrl(
            Uri.parse(post.postVideos![0].url));
        state.chewieController ??= ChewieController(
            videoPlayerController: state.controller!,
            aspectRatio: post.postVideos![0].width / post.postVideos![0].height,
            autoPlay: false,
            autoInitialize: false,
            looping: false,
            customControls: const CupertinoControls(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              iconColor: CupertinoColors.white,
            ),
            placeholder: Image.network(
              post.postVideos![0].thumbnail,
              height: height,
              width: maxWidth * ratio,
              fit: BoxFit.fitHeight,
            ),
            showControlsOnInitialize: false,
            allowPlaybackSpeedChanging: false);
      }
      state.post = post;
      return emit(state);
    } catch (_) {
      return emit(PostState(status: PostStatus.failure));
    }
  }

  Future<Post> getPost(int id) async {
    final token = await Store.secure.read(key: 'jwt');
    final AppUser? user = await UserUtil.getAppUser();
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/posts/$id?userId=${user!.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
