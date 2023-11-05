import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class ImageViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ImageFetched extends ImageViewEvent {
  final int imageId;
  ImageFetched({required this.imageId});
}

final class ImageViewChanged extends ImageViewEvent {
  final Matrix4 transform;
  ImageViewChanged({required this.transform});
}

