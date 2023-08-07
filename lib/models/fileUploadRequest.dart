import 'package:frontend/models/pictureRequestMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'fileUploadRequest.g.dart';

enum FileType {
  @JsonValue("picture")
  picture,
  @JsonValue("video")
  video
}

@JsonSerializable()
class FileUploadRequest {
  @JsonKey(name: 'picture_meta')
  final PictureRequestMeta? pictureMeta;

  @JsonKey(name: 'file_type')
  final FileType fileType;

  const FileUploadRequest({required this.fileType, this.pictureMeta});

  factory FileUploadRequest.fromJson(Map<String, dynamic> json) {
    return _$FileUploadRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FileUploadRequestToJson(this);
  }
}
