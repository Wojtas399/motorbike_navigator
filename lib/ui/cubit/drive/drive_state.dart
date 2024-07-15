import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/coordinates.dart';

part 'drive_state.freezed.dart';

enum DriveStateStatus {
  initial,
  ongoing,
  paused,
  saving,
  saved,
}

extension DriveStateStatusExtensions on DriveStateStatus {
  bool get isInitial => this == DriveStateStatus.initial;

  bool get isOngoing => this == DriveStateStatus.ongoing;
}

@freezed
class DriveState with _$DriveState {
  const DriveState._();

  const factory DriveState({
    @Default(DriveStateStatus.initial) DriveStateStatus status,
    DateTime? startDatetime,
    @Default(Duration.zero) Duration duration,
    @Default(0) double distanceInKm,
    @Default(0) double speedInKmPerH,
    @Default(0) double avgSpeedInKmPerH,
    @Default([]) List<Coordinates> waypoints,
  }) = _DriveState;
}
