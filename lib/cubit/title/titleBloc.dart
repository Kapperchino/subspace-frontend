import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/subscriptionRequest.dart';
import 'package:frontend/cubit/title/titleEvent.dart';
import 'package:frontend/cubit/title/titleState.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../config.dart';
import '../../models/appUser.dart';
import '../../stores/store.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class TitleBloc extends Bloc<TitleEvent, TitleState> {
  TitleBloc({required this.httpClient}) : super(const TitleState()) {
    on<InitEvent>(
      onInit,
      transformer: throttleDroppable(throttleDuration),
    );
    on<JoinEvent>(
      onJoin,
      transformer: throttleDroppable(throttleDuration),
    );
    on<LeaveEvent>(
      onLeave,
      transformer: throttleDroppable(throttleDuration),
    );
    on<HoverEnter>(onHover, transformer: throttleDroppable(throttleDuration));
    on<HoverLeave>(onHoverLeave,
        transformer: throttleDroppable(throttleDuration));
  }

  final http.Client httpClient;

  Future<void> onInit(
    InitEvent event,
    Emitter<TitleState> emit,
  ) async {
    final res = await getSubscription(event.spaceId);
    if (res != 200) {
      return emit(state.copyWith(
          status: TitleStatus.init,
          name: event.name,
          spaceId: event.spaceId,
          buttonName: "Join"));
    }
    return emit(state.copyWith(
        status: TitleStatus.joined,
        name: event.name,
        spaceId: event.spaceId,
        buttonName: "Joined"));
  }

  Future<void> onJoin(
    JoinEvent event,
    Emitter<TitleState> emit,
  ) async {
    final res = await putSubscription();
    if (res != 200) {
      log("failed to join space");
      return emit(state.copyWith(status: TitleStatus.init));
    }
    return emit(
        state.copyWith(status: TitleStatus.joined, buttonName: "Joined"));
  }

  Future<void> onLeave(
    LeaveEvent event,
    Emitter<TitleState> emit,
  ) async {
    final res = await deleteSubscription();
    if (res != 200) {
      log("failed to leave space");
      return emit(state.copyWith(status: TitleStatus.joined));
    }
    return emit(state.copyWith(status: TitleStatus.init, buttonName: "Join"));
  }

  Future<void> onHover(
    event,
    Emitter<TitleState> emit,
  ) async {
    if (state.status == TitleStatus.joined) {
      emit(state.copyWith(buttonName: "Leave"));
    }
  }

  Future<void> onHoverLeave(
    event,
    Emitter<TitleState> emit,
  ) async {
    if (state.status == TitleStatus.joined) {
      emit(state.copyWith(buttonName: "Joined"));
    }
  }

  Future<int> getSubscription(int spaceId) async {
    final AppUser? user = await UserUtil.getAppUser();
    final token = await Store.secure.read(key: 'jwt');
    const baseUrl = "${Config.baseUrl}/subscriptions/users";
    final res = await http.get(
      Uri.parse('$baseUrl/${user!.id}?spaceId=$spaceId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }

  Future<int> putSubscription() async {
    final AppUser? user = await UserUtil.getAppUser();
    final token = await Store.secure.read(key: 'jwt');
    const baseUrl = "${Config.baseUrl}/subscriptions";
    final req = SubscriptionRequest(userId: user!.id, spaceId: state.spaceId);
    final res = await http.put(
      Uri.parse('$baseUrl/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(req.toJson()),
    );
    return res.statusCode;
  }

  Future<int> deleteSubscription() async {
    final AppUser? user = await UserUtil.getAppUser();
    final token = await Store.secure.read(key: 'jwt');
    const baseUrl = "${Config.baseUrl}/subscriptions";
    final res = await http.delete(
      Uri.parse('$baseUrl/?userId=${user!.id}&spaceId=${state.spaceId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }
}
