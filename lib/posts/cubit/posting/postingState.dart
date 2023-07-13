import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum PostingStatus { closed, started, success, failure }

enum PostingMode { text, link, upload }

final class PostingState extends Equatable {
  const PostingState(
      {this.status = PostingStatus.closed,
      this.mode = PostingMode.text,
      this.file});
  final PostingStatus status;
  final PostingMode mode;
  final XFile? file;

  PostingState copyWith(
      {PostingStatus? status, PostingMode? mode, XFile? file}) {
    return PostingState(
        status: status ?? this.status,
        mode: mode ?? this.mode,
        file: file ?? this.file);
  }

  @override
  List<Object> get props => [status, mode, file == null ? "joe" : file!.name];
}
