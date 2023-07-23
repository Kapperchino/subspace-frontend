import 'package:equatable/equatable.dart';

enum TitleStatus { init, joined }

final class TitleState extends Equatable {
  const TitleState(
      {this.status = TitleStatus.init,
      this.name = "",
      this.spaceId = -1,
      this.buttonName = "Join"});
  final TitleStatus status;
  final String name;
  final int spaceId;
  final String buttonName;

  TitleState copyWith(
      {TitleStatus? status, String? name, int? spaceId, String? buttonName}) {
    return TitleState(
        status: status ?? this.status,
        name: name ?? this.name,
        spaceId: spaceId ?? this.spaceId,
        buttonName: buttonName ?? this.buttonName);
  }

  @override
  List<Object> get props => [status, name, spaceId, buttonName];
}
