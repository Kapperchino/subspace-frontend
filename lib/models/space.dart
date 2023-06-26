import 'package:json_annotation/json_annotation.dart';
part 'space.g.dart';

@JsonSerializable()
class Space {
  final int id;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  final String picture;

  const Space(
      {required this.id,
      required this.parentId,
      required this.name,
      required this.description,
      required this.picture});

  factory Space.fromJson(Map<String, dynamic> json) {
    return _$SpaceFromJson(json);
  }
}
