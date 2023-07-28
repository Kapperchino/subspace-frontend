// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updateDeviceReq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDeviceReq _$UpdateDeviceReqFromJson(Map<String, dynamic> json) =>
    UpdateDeviceReq(
      deviceId: json['device_id'] as String,
      registration: json['registration'] as String,
      userId: json['user_id'] as int,
    );

Map<String, dynamic> _$UpdateDeviceReqToJson(UpdateDeviceReq instance) =>
    <String, dynamic>{
      'registration': instance.registration,
      'device_id': instance.deviceId,
      'user_id': instance.userId,
    };
