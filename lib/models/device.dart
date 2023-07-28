import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'device.g.dart';

@JsonSerializable()
class Device {
  @JsonKey(name: 'registration')
  final String registration;
  @JsonKey(name: 'device_id')
  final String deviceId;

  const Device({required this.deviceId, required this.registration});

  factory Device.fromJson(Map<String, dynamic> json) {
    return _$DeviceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeviceToJson(this);
  }
}
