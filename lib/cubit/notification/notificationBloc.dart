import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/notification/notificationEvent.dart';
import 'package:frontend/cubit/notification/notificationState.dart';
import 'package:frontend/models/mentionNotification.dart';
import 'package:frontend/models/replyNotification.dart';
import 'package:frontend/notification/notificationWidget.dart';
import 'package:http/http.dart' as http;
import 'package:localstore/localstore.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required this.httpClient})
      : super(const NotificationState()) {
    on<NotificationsFetched>(
      _onNotificationsFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<NotificationSaw>(
      _onSeenNotification,
      transformer: throttleDroppable(throttleDuration),
    );
    on<MentionSaw>(
      _onSeenMention,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onNotificationsFetched(
    NotificationsFetched event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final mentions = await getMentions();
      final notifications = await getNotifications();
      return emit(state.copyWith(
          status: NotificationStatus.success,
          mentions: mentions,
          notifications: notifications));
    } catch (_) {
      return emit(state.copyWith(
        status: NotificationStatus.failure,
      ));
    }
  }

  Future<void> _onSeenNotification(
    NotificationSaw event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final db = Localstore.instance;
      await db.collection("notification-reply").doc(event.id).delete();
      final notifications = await getNotifications();
      return emit(state.copyWith(
          status: NotificationStatus.success, notifications: notifications));
    } catch (_) {
      return emit(state.copyWith(
        status: NotificationStatus.failure,
      ));
    }
  }

  Future<void> _onSeenMention(
    MentionSaw event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final db = Localstore.instance;
      await db.collection("notification-mentions").doc(event.id).delete();
      final mentions = await getMentions();
      return emit(state.copyWith(
        status: NotificationStatus.success,
        mentions: mentions,
      ));
    } catch (_) {
      return emit(state.copyWith(
        status: NotificationStatus.failure,
      ));
    }
  }

  Future<List<NotificationWidget>?> getNotifications() async {
    final db = Localstore.instance;
    final mentions = await db.collection("notification-mentions").get();
    final mentionList =
        mentions?.values.map((e) => MentionNotification.fromJson(e)).toList();

    final replies = await db.collection("notification-reply").get();
    final replyList = replies?.values
        .map((event) => ReplyNotification.fromJson(event))
        .toList();
    List<NotificationWidget> widgets = List.empty(growable: true);
    if (replyList != null) {
      widgets.addAll(replyList.map((r) => NotificationWidget(
            replyNotification: r,
            sendTime: r.sentDate,
          )));
    }
    if (mentionList != null) {
      widgets.addAll(mentionList.map((r) => NotificationWidget(
            mentionNotification: r,
            sendTime: r.sentDate,
          )));
    }
    widgets.sort((a, b) {
      return a.sendTime.compareTo(b.sendTime);
    });
    return widgets;
  }

  Future<List<NotificationWidget>?> getMentions() async {
    final db = Localstore.instance;
    final mentions = await db.collection("notification-mentions").get();
    final mentionList =
        mentions?.values.map((e) => MentionNotification.fromJson(e)).toList();
    final widgets = mentionList?.map((m) {
      return NotificationWidget(
        mentionNotification: m,
        sendTime: m.sentDate,
      );
    }).toList();

    widgets?.sort((a, b) {
      return a.sendTime.compareTo(b.sendTime);
    });
    return widgets;
  }
}
