import 'package:equatable/equatable.dart';

sealed class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class NotificationsFetched extends NotificationEvent {
  NotificationsFetched();
}

final class NotificationSaw extends NotificationEvent {
  String id;
  NotificationSaw({required this.id});
}

final class MentionSaw extends NotificationEvent {
  String id;
  MentionSaw({required this.id});
}
