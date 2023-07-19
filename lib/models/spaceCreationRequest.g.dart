// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaceCreationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceCreationRequest _$SpaceCreationRequestFromJson(
        Map<String, dynamic> json) =>
    SpaceCreationRequest(
      parentId: json['parent'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      picture: json['picture'] as String,
    );

Map<String, dynamic> _$SpaceCreationRequestToJson(
        SpaceCreationRequest instance) =>
    <String, dynamic>{
      'parent': instance.parentId,
      'name': instance.name,
      'description': instance.description,
      'picture': instance.picture,
    };
