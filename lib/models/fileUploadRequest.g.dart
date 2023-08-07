// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileUploadRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadRequest _$FileUploadRequestFromJson(Map<String, dynamic> json) =>
    FileUploadRequest(
      fileType: $enumDecode(_$FileTypeEnumMap, json['file_type']),
      pictureMeta: json['picture_meta'] == null
          ? null
          : PictureRequestMeta.fromJson(
              json['picture_meta'] as Map<String, dynamic>),
      isLink: json['is_link'] as bool?,
    );

Map<String, dynamic> _$FileUploadRequestToJson(FileUploadRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('picture_meta', instance.pictureMeta);
  val['file_type'] = _$FileTypeEnumMap[instance.fileType]!;
  writeNotNull('is_link', instance.isLink);
  return val;
}

const _$FileTypeEnumMap = {
  FileType.picture: 'picture',
  FileType.video: 'video',
};
