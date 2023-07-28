import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/post.dart';
part 'userWidget.g.dart';


@JsonSerializable()
class UserWidget {
  final int id;
  final String displayName;
  final String bio;
  final List<Post> posts;

  const UserWidget ({
    required this.id,
    required this.displayName,
    this.bio = "",
    required this.posts
  });

  factory UserWidget.fromJson(Map<String, dynamic> json) {
    return _$UserWidgetFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserWidgetToJson(this);
  }
}