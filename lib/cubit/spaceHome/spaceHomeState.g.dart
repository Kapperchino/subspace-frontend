// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaceHomeState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceHomeState _$SpaceHomeStateFromJson(Map<String, dynamic> json) =>
    SpaceHomeState(
      status: $enumDecodeNullable(_$SpaceHomeStatusEnumMap, json['status']) ??
          SpaceHomeStatus.initial,
      popularSpaces: (json['popularSpaces'] as List<dynamic>?)
          ?.map((e) => Space.fromJson(e as Map<String, dynamic>))
          .toList(),
      latestSpaces: (json['latestSpaces'] as List<dynamic>?)
          ?.map((e) => Space.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpaceHomeStateToJson(SpaceHomeState instance) {
  final val = <String, dynamic>{
    'status': _$SpaceHomeStatusEnumMap[instance.status]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('popularSpaces', instance.popularSpaces);
  writeNotNull('latestSpaces', instance.latestSpaces);
  return val;
}

const _$SpaceHomeStatusEnumMap = {
  SpaceHomeStatus.initial: 'initial',
  SpaceHomeStatus.success: 'success',
  SpaceHomeStatus.failure: 'failure',
};
