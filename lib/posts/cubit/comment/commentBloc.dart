import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/CommentData.dart';
import 'package:frontend/posts/cubit/comment/commentEvent.dart';
import 'package:frontend/posts/cubit/comment/commentState.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/comment.dart';
import '../../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CommentBloc extends Bloc<CommentEvent, CommentsState> {
  CommentBloc({required this.httpClient}) : super(const CommentsState()) {
    on<CommentsFetched>(
      _onCommentsFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onCommentsFetched(
    CommentsFetched event,
    Emitter<CommentsState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == CommentsStatus.initial) {
        final comments = await getComments(event.postId);
        return emit(
          state.copyWith(
            status: CommentsStatus.success,
            comments: comments,
            hasReachedMax: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: CommentsStatus.failure));
    }
  }

  Future<List<CommentData>>? getComments(int postId) async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/comments?postId=$postId'),
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
      final List<dynamic> list = jsonDecode(res.body);
      final List<CommentData> comments = list.map((e) {
        final comment = Comment.fromJson(e);
        return CommentData(
            comment: comment, children: List.empty(growable: true));
      }).toList(growable: false);
      Map<int, CommentData> map = HashMap();
      List<CommentData> resList = List.empty(growable: true);
      for (var comment in comments) {
        map[comment.comment.id] = comment;
      }
      map.forEach((key, value) {
        if (!map.containsKey(value.comment.parentId)) {
          resList.add(value);
        } else {
          map[value.comment.parentId]!.children.add(value);
        }
      });

      return resList;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
