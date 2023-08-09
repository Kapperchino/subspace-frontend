import 'package:frontend/models/device.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login.g.dart';

@JsonSerializable(includeIfNull: false)
class LogIn {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'device')
  final Device? device;

  const LogIn({required this.email, required this.password, this.device});

  factory LogIn.fromJson(Map<String, dynamic> json) {
    return _$LogInFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$LogInToJson(this);
  }
}
