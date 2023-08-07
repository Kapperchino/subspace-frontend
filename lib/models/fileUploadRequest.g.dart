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
    );

Map<String, dynamic> _$FileUploadRequestToJson(FileUploadRequest instance) =>
    <String, dynamic>{
      'picture_meta': instance.pictureMeta,
      'file_type': _$FileTypeEnumMap[instance.fileType]!,
    };

const _$FileTypeEnumMap = {
  FileType.picture: 'picture',
  FileType.video: 'video',
};
