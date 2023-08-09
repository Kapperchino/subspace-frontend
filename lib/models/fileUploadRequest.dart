import 'package:frontend/models/pictureRequestMeta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'fileUploadRequest.g.dart';

enum FileType {
  @JsonValue("picture")
  picture,
  @JsonValue("video")
  video
}

@JsonSerializable(includeIfNull: false)
class FileUploadRequest {
  @JsonKey(name: 'picture_meta')
  final PictureRequestMeta? pictureMeta;

  @JsonKey(name: 'file_type')
  final FileType fileType;

  @JsonKey(name: 'is_link')
  final bool? isLink;

  const FileUploadRequest(
      {required this.fileType, this.pictureMeta, this.isLink});

  factory FileUploadRequest.fromJson(Map<String, dynamic> json) {
    return _$FileUploadRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FileUploadRequestToJson(this);
  }
}
