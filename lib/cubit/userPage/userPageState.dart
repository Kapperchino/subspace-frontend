import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/postCardData.dart';

import '../../models/userMeta.dart';
import '../space/spaceState.dart';

enum UserPageStatus { initial, success, failure }

enum BioEditStatus { start, edit, success, failure }

enum PicEditStatus { start, success, failure }

final class UserPageState extends Equatable {
  const UserPageState(
      {this.status = UserPageStatus.initial,
      this.sortState = SortStatus.latest,
      this.bioStatus = BioEditStatus.start,
      this.posts = const <PostCardData>[],
      this.sortDays = SortDays.week,
      this.hasReachedMax = false,
      this.picEditStatus = PicEditStatus.start,
      required this.controller,
      this.user});

  final UserPageStatus status;
  final BioEditStatus bioStatus;
  final List<PostCardData> posts;
  final bool hasReachedMax;
  final SortStatus sortState;
  final SortDays sortDays;
  final UserMeta? user;
  final TextEditingController controller;
  final PicEditStatus picEditStatus;

  UserPageState copyWith(
      {SortDays? days,
      UserPageStatus? status,
      List<PostCardData>? posts,
      bool? hasReachedMax,
      SortStatus? sortState,
      PicEditStatus? picEditStatus,
      BioEditStatus? bioStatus,
      UserMeta? user,
      TextEditingController? controller}) {
    return UserPageState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        sortState: sortState ?? this.sortState,
        sortDays: days ?? sortDays,
        controller: controller ?? this.controller,
        bioStatus: bioStatus ?? this.bioStatus,
        picEditStatus: picEditStatus ?? this.picEditStatus,
        user: user ?? this.user);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [
        status,
        posts,
        hasReachedMax,
        sortState,
        user ?? -1,
        controller,
        bioStatus,
        picEditStatus,
      ];
}
