import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:image_picker/image_picker.dart';

sealed class UserPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class UserPageInit extends UserPageEvent {
  final int userId;
  UserPageInit({required this.userId});
}

final class UserPageBioToggle extends UserPageEvent {
  UserPageBioToggle();
}

final class UserPagePicUpload extends UserPageEvent {
  XFile? file;
  UserPagePicUpload({required this.file});
}

final class UserPageFetched extends UserPageEvent {
  final int userId;

  UserPageFetched({required this.userId});
}

final class UserPageSortChanged extends UserPageEvent {
  final SortStatus sortState;

  UserPageSortChanged({required this.sortState});
}

final class UserPageDaysSortChanged extends UserPageEvent {
  final SortDays sortDays;

  UserPageDaysSortChanged({required this.sortDays});
}
