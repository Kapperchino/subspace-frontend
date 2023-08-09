import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/fileUploadRequest.dart';
import 'package:frontend/models/pictureMetaResult.dart';
import 'package:frontend/models/pictureRequestMeta.dart';
import 'package:frontend/posts/cubit/posting/postingEvent.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:mime/mime.dart';
import 'package:stream_transform/stream_transform.dart';

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
    on<FileChanged>((event, emit) => onFileChange(event, emit));
  }

  final http.Client httpClient;

  void onFileChange(
    FileChanged event,
    Emitter<PostingState> emit,
  ) {
    return emit(state.copyWith(file: event.file));
  }

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
    if (state.status == PostingStatus.started ||
        state.status == PostingStatus.failure) {
      if (event.body.isEmpty &&
          event.content.isEmpty &&
          state.mode != PostingMode.upload &&
          state.file == null) {
        return emit(state.copyWith(
          status: PostingStatus.failure,
        ));
      }
      if (event.body.length >= 60000 || event.topic.length >= 6000) {
        return emit(state.copyWith(
          status: PostingStatus.failure,
        ));
      }
      switch (state.mode) {
        case PostingMode.link:
          {
            final type = await getContentTypeUrl(event.content);
            final int res = await postPost(
                event.body, event.topic, event.spaceId,
                content: event.content, contentType: type);
            if (res != 200) {
              return emit(state.copyWith(
                status: PostingStatus.failure,
              ));
            }
            return emit(
              state.copyWith(status: PostingStatus.success),
            );
          }
        case PostingMode.text:
          {
            final int res =
                await postPost(event.body, event.topic, event.spaceId);
            if (res != 200) {
              return emit(state.copyWith(
                status: PostingStatus.failure,
              ));
            }
            return emit(
              state.copyWith(status: PostingStatus.success),
            );
          }
        case PostingMode.upload:
          {
            final type = getContentType();
            final res = await postPost(event.body, event.topic, event.spaceId,
                content: event.content, contentType: type);
            if (res != 200) {
              return emit(state.copyWith(
                status: PostingStatus.failure,
              ));
            }
            return emit(
              state.copyWith(status: PostingStatus.success, file: null),
            );
          }
      }
    }
  }

  Future<ContentType> getContentTypeUrl(String url) async {
    try {
      String? mime = lookupMimeType(url);
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

  ContentType getContentType() {
    try {
      String? mime;
      if (state.file!.mimeType != null) {
        mime = state.file!.mimeType;
      } else {
        mime = lookupMimeType(state.file!.path);
      }
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
    final List<int> fileIds = List.empty(growable: true);
    String? link;
    if (state.mode == PostingMode.link) {
      if (contentType == ContentType.picture) {
        final res = await http.get(Uri.parse(content));
        final bytes = res.bodyBytes;
        final codec = await instantiateImageCodec(bytes);
        final frameInfo = await codec.getNextFrame();
        final image = frameInfo.image;
        final pictureMeta = PictureRequestMeta(
            width: image.width, height: image.height, url: content);
        final json = jsonEncode(FileUploadRequest(
            fileType: FileType.picture,
            pictureMeta: pictureMeta,
            isLink: true));
        final putRes = await http.put(
          Uri.parse('${Config.baseUrl}/files'),
          body: json,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
        );
        if (res.statusCode != 200) {
          throw const HttpException("should not get non 200");
        }
        final resMeta = PictureMetaResult.fromJson(jsonDecode(putRes.body));
        fileIds.add(resMeta.id);
      } else {
        link = content;
      }
    } else if (getContentType() == ContentType.picture) {
      final file = File(state.file!.path);
      final size = ImageSizeGetter.getSize(FileInput(file));
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
      fileIds.add(resMeta.id);

      String? mimeStr;
      if (state.file!.mimeType != null) {
        mimeStr = state.file!.mimeType;
      } else {
        mimeStr = lookupMimeType(state.file!.path);
      }
      Uri uri = Uri.parse(resMeta.presigned);
      final fileRes = await http.put(uri,
          body: await state.file?.readAsBytes(),
          headers: {"Content-Type": mimeStr!});
      if (fileRes.statusCode != 200) {
        return fileRes.statusCode;
      }
    }

    final json = jsonEncode(PostRequest(
            type: contentType,
            topic: topic,
            spaceId: spaceId,
            posterId: user.id,
            fileIds: fileIds,
            body: body,
            link: link)
        .toJson());

    final res = await http.post(
      Uri.parse('${Config.baseUrl}/posts'),
      body: json,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    return res.statusCode;
  }
}
