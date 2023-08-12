import 'package:equatable/equatable.dart';

sealed class ImageViewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ImageFetched extends ImageViewEvent {
  final int imageId;
  ImageFetched({required this.imageId});
}
