import 'package:json_annotation/json_annotation.dart';
part 'tagMeta.g.dart';

@JsonSerializable()
class TagMeta {
  final String name;
  final int count;

  const TagMeta({required this.name, required this.count});

  factory TagMeta.fromJson(Map<String, dynamic> json) {
    return _$TagMetaFromJson(json);
  }
}
