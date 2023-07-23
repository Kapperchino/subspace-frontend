import 'package:equatable/equatable.dart';
import 'package:frontend/models/voteRequest.dart';
import 'package:frontend/posts/cubit/vote/voteState.dart';

sealed class TitleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class InitEvent extends TitleEvent {
  final int spaceId;
  final String name;
  InitEvent(this.spaceId, this.name);
}

final class HoverEnter extends TitleEvent {
  HoverEnter();
}

final class HoverLeave extends TitleEvent {
  HoverLeave();
}

final class JoinEvent extends TitleEvent {
  JoinEvent();
}

final class LeaveEvent extends TitleEvent {
  LeaveEvent();
}
