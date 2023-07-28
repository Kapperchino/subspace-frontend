import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ProfileFetched extends ProfileEvent {
  final int userId;
  ProfileFetched({required this.userId});
}
