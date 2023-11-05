import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/pictureMeta.dart';

enum ImageViewStatus { initial, success, failure }

final class ImageViewState extends Equatable {
  const ImageViewState(
      {this.status = ImageViewStatus.initial,
      this.pictureMeta,
      required this.transform});

  final ImageViewStatus status;
  final PictureMeta? pictureMeta;
  final Matrix4 transform;

  ImageViewState copyWith(
      {PictureMeta? pictureMeta, ImageViewStatus? status, Matrix4? transform}) {
    return ImageViewState(
        status: status ?? this.status,
        pictureMeta: pictureMeta ?? this.pictureMeta,
        transform: transform ?? this.transform);
  }

  @override
  String toString() {
    return '''ImageViewStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, pictureMeta ?? -1, transform];
}
