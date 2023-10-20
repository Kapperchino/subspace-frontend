import 'package:json_annotation/json_annotation.dart';
part 'spaceCreationRequest.g.dart';

@JsonSerializable(explicitToJson: true)
class SpaceCreationRequest {
  @JsonKey(name: 'parent')
  final int parentId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  final String picture;

  const SpaceCreationRequest(
      {required this.parentId,
      required this.name,
      required this.description,
      required this.picture});

  factory SpaceCreationRequest.fromJson(Map<String, dynamic> json) {
    return _$SpaceCreationRequestFromJson(json);
  }

  toJson() {
    return _$SpaceCreationRequestToJson(this);
  }
}
