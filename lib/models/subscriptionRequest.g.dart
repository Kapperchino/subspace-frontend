// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptionRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionRequest _$SubscriptionRequestFromJson(Map<String, dynamic> json) =>
    SubscriptionRequest(
      userId: json['user_id'] as int,
      spaceId: json['space_id'] as int,
    );

Map<String, dynamic> _$SubscriptionRequestToJson(
        SubscriptionRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'space_id': instance.spaceId,
    };
