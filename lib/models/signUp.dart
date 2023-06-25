import 'package:json_annotation/json_annotation.dart';
part 'signUp.g.dart';

@JsonSerializable()
class SignUpRequest {
  final String password;
  @JsonKey(name: "display_name")
  final String displayName;
  final String email;

  const SignUpRequest(
      {required this.password, required this.displayName, required this.email});

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return _$SignUpRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SignUpRequestToJson(this);
  }
}
