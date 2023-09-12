// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spaceState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceState _$SpaceStateFromJson(Map<String, dynamic> json) => SpaceState(
      status: $enumDecodeNullable(_$SpaceStatusEnumMap, json['status']) ??
          SpaceStatus.initial,
      sortState: $enumDecodeNullable(_$SortStatusEnumMap, json['sortState']) ??
          SortStatus.latest,
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => PostCardData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PostCardData>[],
      sortDays: $enumDecodeNullable(_$SortDaysEnumMap, json['sortDays']) ??
          SortDays.week,
      hasReachedMax: json['hasReachedMax'] as bool? ?? false,
      spaceId: json['spaceId'] as int? ?? -1,
      parentId: json['parentId'] as int? ?? -1,
      spaceName: json['spaceName'] as String? ?? "",
      backgroundPicture: json['backgroundPicture'] == null
          ? null
          : PictureMeta.fromJson(
              json['backgroundPicture'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpaceStateToJson(SpaceState instance) {
  final val = <String, dynamic>{
    'status': _$SpaceStatusEnumMap[instance.status]!,
    'posts': instance.posts,
    'hasReachedMax': instance.hasReachedMax,
    'sortState': _$SortStatusEnumMap[instance.sortState]!,
    'sortDays': _$SortDaysEnumMap[instance.sortDays]!,
    'spaceId': instance.spaceId,
    'parentId': instance.parentId,
    'spaceName': instance.spaceName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backgroundPicture', instance.backgroundPicture);
  return val;
}

const _$SpaceStatusEnumMap = {
  SpaceStatus.initial: 'initial',
  SpaceStatus.success: 'success',
  SpaceStatus.failure: 'failure',
};

const _$SortStatusEnumMap = {
  SortStatus.latest: 'latest',
  SortStatus.popular: 'popular',
};

const _$SortDaysEnumMap = {
  SortDays.week: 'week',
  SortDays.month: 'month',
  SortDays.halfYear: 'halfYear',
  SortDays.year: 'year',
};
