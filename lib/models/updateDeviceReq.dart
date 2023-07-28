import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'updateDeviceReq.g.dart';

@JsonSerializable()
class UpdateDeviceReq {
  @JsonKey(name: 'registration')
  final String registration;
  @JsonKey(name: 'device_id')
  final String deviceId;
  @JsonKey(name: 'user_id')
  final int userId;

  const UpdateDeviceReq(
      {required this.deviceId,
      required this.registration,
      required this.userId});

  factory UpdateDeviceReq.fromJson(Map<String, dynamic> json) {
    return _$UpdateDeviceReqFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UpdateDeviceReqToJson(this);
  }
}
