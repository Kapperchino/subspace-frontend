// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signUp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      password: json['password'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String,
      address: json['user_address'] as String,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'password': instance.password,
      'display_name': instance.displayName,
      'email': instance.email,
      'user_address': instance.address,
    };
