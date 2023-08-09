import 'package:json_annotation/json_annotation.dart';
part 'subscriptionRequest.g.dart';

@JsonSerializable()
class SubscriptionRequest {
  @JsonKey(name: "user_id")
  final int userId;
  @JsonKey(name: "space_id")
  final int spaceId;

  const SubscriptionRequest(
      {required this.userId,
      required this.spaceId});

  factory SubscriptionRequest.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubscriptionRequestToJson(this);
  }
}
