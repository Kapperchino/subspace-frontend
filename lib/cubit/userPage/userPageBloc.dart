import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:frontend/cubit/userPage/userPageEvent.dart';
import 'package:frontend/cubit/userPage/userPageState.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:mime/mime.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../models/fileUploadRequest.dart';
import '../../models/pictureMetaResult.dart';
import '../../models/pictureRequestMeta.dart';
import '../../models/userMeta.dart';
import '../../stores/store.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserPageBloc extends Bloc<UserPageEvent, UserPageState> {
  UserPageBloc({required this.httpClient})
      : super(UserPageState(controller: TextEditingController())) {
    on<UserPageFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageSortChanged>(
      _onSortChange,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageDaysSortChanged>(
      _onDaysChange,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageInit>(
      _onInit,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPageBioToggle>(
      _onBioEdit,
      transformer: throttleDroppable(throttleDuration),
    );
    on<UserPagePicUpload>(
      _onPicUpdate,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPicUpdate(
      UserPagePicUpload event, Emitter<UserPageState> emit) async {
    if (event.file == null) {
      return emit(state.copyWith(picEditStatus: PicEditStatus.start));
    }
    final res = await uploadPic(event.file!);
    if (res != 200) {
      return emit(state.copyWith(picEditStatus: PicEditStatus.failure));
    }
    return emit(state.copyWith(picEditStatus: PicEditStatus.success));
  }

  Future<void> _onBioEdit(
    UserPageBioToggle event,
    Emitter<UserPageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (state.bioStatus != BioEditStatus.edit) {
      return emit(state.copyWith(bioStatus: BioEditStatus.edit));
    }
    if (state.controller.text != state.user!.bio) {
      final token = await Store.secure.read(key: 'jwt');
      final res = await httpClient.put(
          Uri.parse('${Config.baseUrl}/users/${state.user!.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"bio": state.controller.text}));
      if (res.statusCode == 200) {
        return emit(state.copyWith(bioStatus: BioEditStatus.success));
      }
      return emit(state.copyWith(bioStatus: BioEditStatus.failure));
    }
    return emit(state.copyWith(bioStatus: BioEditStatus.start));
  }

  Future<void> _onInit(
    UserPageInit event,
    Emitter<UserPageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await getPosts(event.userId);
      return emit(
        state.copyWith(
            status: UserPageStatus.success,
            posts: posts.$1,
            user: posts.$2,
            hasReachedMax: false,
            controller: TextEditingController(text: posts.$2.bio)),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<void> _onDaysChange(
    UserPageDaysSortChanged event,
    Emitter<UserPageState> emit,
  ) async {
    try {
      final posts = await getPosts(state.user!.id,
          sort: state.sortState, days: event.sortDays);
      return emit(
        state.copyWith(
          days: event.sortDays,
          status: UserPageStatus.success,
          posts: posts.$1,
          user: posts.$2,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<void> _onSortChange(
    UserPageSortChanged event,
    Emitter<UserPageState> emit,
  ) async {
    try {
      final posts = await getPosts(state.user!.id,
          sort: event.sortState, days: state.sortDays);
      return emit(
        state.copyWith(
          sortState: event.sortState,
          status: UserPageStatus.success,
          posts: posts.$1,
          user: posts.$2,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<void> _onPostFetched(
    UserPageFetched event,
    Emitter<UserPageState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await getPosts(event.userId,
          sort: state.sortState, days: state.sortDays);
      return emit(
        state.copyWith(
          status: UserPageStatus.success,
          posts: posts.$1,
          user: posts.$2,
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UserPageStatus.failure));
    }
  }

  Future<(List<PostCardData>, UserMeta)> getPosts(int userId,
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
    final userInfo = await http.get(
      Uri.parse('${Config.baseUrl}/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    final user = UserMeta.fromJson(jsonDecode(utf8.decode(userInfo.bodyBytes)));
    final res = await http.get(
      Uri.parse(
          '${Config.baseUrl}/posts/users/$userId?sort=${sort.name}&days=$intDays'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        List<PostCardData> list = List.empty();
        return (list, user);
      }
      final List<dynamic> list = jsonDecode(utf8.decode(res.bodyBytes));
      var output = List<PostCardData>.empty(growable: true);
      for (final json in list) {
        final post = Post.fromJson(json);
        output.add(PostCardData(
          spaceName: "",
          post: post,
        ));
      }
      return (output, user);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<int> uploadPic(XFile file) async {
    final token = await Store.secure.read(key: 'jwt');
    final mem = await file.readAsBytes();
    final size = ImageSizeGetter.getSize(MemoryInput(mem));
    final pictureMeta =
        PictureRequestMeta(width: size.width, height: size.height);
    final json = jsonEncode(FileUploadRequest(
        fileType: FileType.picture, pictureMeta: pictureMeta));
    final res = await http.put(
      Uri.parse('${Config.baseUrl}/files'),
      body: json,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      return res.statusCode;
    }
    final resMeta = PictureMetaResult.fromJson(jsonDecode(res.body));
    final AppUser? user = await UserUtil.getAppUser();

    final userRes = await http.put(
      Uri.parse('${Config.baseUrl}/users/${user!.id}/picture'),
      body: jsonEncode({'picture_id': resMeta.id}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (userRes.statusCode != 200) {
      return userRes.statusCode;
    }
    await UserUtil.saveUser(AppUser(
        id: user.id,
        displayName: user.displayName,
        email: user.email,
        address: user.address,
        picture: PictureMeta(
            height: resMeta.height,
            width: resMeta.width,
            id: resMeta.id,
            url: resMeta.url)));
    String? mimeStr;
    if (file.mimeType != null) {
      mimeStr = file.mimeType;
    } else {
      mimeStr = lookupMimeType(file.path);
    }
    Uri uri = Uri.parse(resMeta.presigned);
    final fileRes = await http.put(uri,
        body: await file.readAsBytes(), headers: {"Content-Type": mimeStr!});
    if (fileRes.statusCode != 200) {
      return fileRes.statusCode;
    }
    return 200;
  }
}
