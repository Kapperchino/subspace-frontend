// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userWidget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWidget _$UserWidgetFromJson(Map<String, dynamic> json) => UserWidget(
      id: json['id'] as int,
      displayName: json['displayName'] as String,
      bio: json['bio'] as String? ?? "",
      posts: (json['posts'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserWidgetToJson(UserWidget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'bio': instance.bio,
      'posts': instance.posts,
    };
