import 'package:json_annotation/json_annotation.dart';
part 'signUp.g.dart';

@JsonSerializable(explicitToJson: true)
class SignUpRequest {
  final String password;
  @JsonKey(name: "display_name")
  final String displayName;
  final String email;
  @JsonKey(name: "user_address")
  final String address;

  const SignUpRequest(
      {required this.password,
      required this.displayName,
      required this.email,
      required this.address});

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return _$SignUpRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SignUpRequestToJson(this);
  }
}
