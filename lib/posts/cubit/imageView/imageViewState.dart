import 'package:equatable/equatable.dart';
import 'package:frontend/models/pictureMeta.dart';

enum ImageViewStatus { initial, success, failure }

final class ImageViewState extends Equatable {
  const ImageViewState(
      {this.status = ImageViewStatus.initial, this.pictureMeta});

  final ImageViewStatus status;
  final PictureMeta? pictureMeta;

  ImageViewState copyWith({PictureMeta? pictureMeta, ImageViewStatus? status}) {
    return ImageViewState(
        status: status ?? this.status,
        pictureMeta: pictureMeta ?? this.pictureMeta);
  }

  @override
  String toString() {
    return '''ImageViewStatus { status: $status }''';
  }

  @override
  List<Object> get props => [status, pictureMeta ?? -1];
}
