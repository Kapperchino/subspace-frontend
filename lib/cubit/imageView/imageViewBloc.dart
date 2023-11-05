import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/cubit/imageView/imageViewEvent.dart';
import 'package:frontend/cubit/imageView/imageViewState.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../../config.dart';
import '../../../../models/appUser.dart';
import '../../../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ImageViewBloc extends Bloc<ImageViewEvent, ImageViewState> {
  ImageViewBloc({required this.httpClient})
      : super(ImageViewState(transform: Matrix4.identity())) {
    on<ImageFetched>(
      _onImageFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<ImageViewChanged>(_onTransformChange);
  }

  final http.Client httpClient;

  Future<void> _onTransformChange(
    ImageViewChanged event,
    Emitter<ImageViewState> emit,
  ) async {
    return emit(
      state.copyWith(transform: event.transform),
    );
  }

  Future<void> _onImageFetched(
    ImageFetched event,
    Emitter<ImageViewState> emit,
  ) async {
    try {
      final image = await getImage(event.imageId);
      return emit(
        state.copyWith(status: ImageViewStatus.success, pictureMeta: image),
      );
    } catch (_) {
      return emit(state.copyWith(status: ImageViewStatus.failure));
    }
  }

  Future<PictureMeta?> getImage(int imageId) async {
    final token = await Store.secure.read(key: 'jwt');
    final AppUser? user = await UserUtil.getAppUser();
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/files/$imageId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return null;
      }
      return PictureMeta.fromJson(jsonDecode(res.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
