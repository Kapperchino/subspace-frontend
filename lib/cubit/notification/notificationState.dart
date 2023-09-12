import 'package:equatable/equatable.dart';
import 'package:frontend/notification/notificationWidget.dart';

enum NotificationStatus { initial, success, failure }

final class NotificationState extends Equatable {
  const NotificationState(
      {this.status = NotificationStatus.initial,
      this.notifications,
      this.mentions});

  final NotificationStatus status;
  final List<NotificationWidget>? notifications;
  final List<NotificationWidget>? mentions;

  NotificationState copyWith(
      {NotificationStatus? status,
      List<NotificationWidget>? notifications,
      List<NotificationWidget>? mentions}) {
    return NotificationState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        mentions: mentions ?? this.mentions);
  }

  @override
  String toString() {
    return '''SearchState { status: $status}''';
  }

  @override
  List<Object> get props => [status, notifications ?? 1, mentions ?? 1];
}
