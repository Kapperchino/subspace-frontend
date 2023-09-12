import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/votesMeta.dart';
import 'package:frontend/cubit/vote/voteEvent.dart';
import 'package:frontend/cubit/vote/voteState.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../models/voteRequest.dart';
import '../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class VoteBloc extends Bloc<VoteEvent, VotingState> {
  final VoteType type;
  VoteBloc({required this.httpClient, required this.type})
      : super(VotingState(voteType: type)) {
    on<UpvoteEvent>(
      _onUpvote,
      transformer: throttleDroppable(throttleDuration),
    );
    on<DownvoteEvent>(
      _onDownvote,
      transformer: throttleDroppable(throttleDuration),
    );
    on<InitEvent>(
      _onInit,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onUpvote(
    UpvoteEvent event,
    Emitter<VotingState> emit,
  ) async {
    final code = await upvote();
    if (code != 200) {
      throw const HttpException("error upvoting");
    }
    final tuple = await getVotes();
    return emit(
        state.copyWith(status: tuple.$3, likes: tuple.$1, dislikes: tuple.$2));
  }

  Future<void> _onDownvote(
    DownvoteEvent event,
    Emitter<VotingState> emit,
  ) async {
    final code = await downvote();
    if (code != 200) {
      throw const HttpException("error downvoting");
    }
    final tuple = await getVotes();
    return emit(
        state.copyWith(status: tuple.$3, likes: tuple.$1, dislikes: tuple.$2));
  }

  Future<void> _onInit(
    InitEvent event,
    Emitter<VotingState> emit,
  ) async {
    return emit(state.copyWith(
        id: event.id,
        likes: event.likes,
        dislikes: event.dislikes,
        status: event.status,
        type: event.type));
  }

  Future<int> upvote() async {
    final AppUser? user = await UserUtil.getAppUser();
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/votes'),
      body: jsonEncode(VoteRequest(
              isUpvote: true,
              userId: user!.id,
              postOrCommentId: state.id,
              voteType: state.voteType)
          .toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }

  Future<int> downvote() async {
    final AppUser? user = await UserUtil.getAppUser();
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/votes'),
      body: jsonEncode(VoteRequest(
              isUpvote: false,
              userId: user!.id,
              postOrCommentId: state.id,
              voteType: state.voteType)
          .toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }

  Future<(int, int, VotingStatus)> getVotes() async {
    final AppUser? user = await UserUtil.getAppUser();
    final token = await Store.secure.read(key: 'jwt');
    var baseUrl = "";
    if (state.voteType == VoteType.post) {
      baseUrl = "${Config.baseUrl}/votes/posts";
    } else {
      baseUrl = "${Config.baseUrl}/votes/comments";
    }
    final res = await http.get(
      Uri.parse('$baseUrl/${state.id}?userId=${user!.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      throw const HttpException("Not 200");
    }
    if (res.body == 'null' || res.body.isEmpty || res.body == 'OK') {
      return (0, 0, VotingStatus.init);
    }
    final VotesMeta meta = VotesMeta.fromJson(jsonDecode(res.body));
    var voteStatus = VotingStatus.init;
    if (meta.isDeleted) {
      voteStatus = VotingStatus.init;
    } else {
      if (meta.isUpvote) {
        voteStatus = VotingStatus.liked;
      } else {
        voteStatus = VotingStatus.disliked;
      }
    }
    return (meta.upVotes, meta.downVotes, voteStatus);
  }
}
