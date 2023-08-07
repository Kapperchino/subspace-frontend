// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pictureRequestMeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureRequestMeta _$PictureRequestMetaFromJson(Map<String, dynamic> json) =>
    PictureRequestMeta(
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PictureRequestMetaToJson(PictureRequestMeta instance) {
  final val = <String, dynamic>{
    'width': instance.width,
    'height': instance.height,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('url', instance.url);
  return val;
}
