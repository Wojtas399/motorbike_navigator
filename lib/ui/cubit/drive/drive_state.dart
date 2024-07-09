import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/coordinates.dart';

part 'drive_state.freezed.dart';

enum DriveStateStatus { initial, ongoing, finished, saving, saved }

@freezed
class DriveState with _$DriveState {
  const DriveState._();

  const factory DriveState({
    @Default(DriveStateStatus.initial) DriveStateStatus status,
    @Default(Duration.zero) Duration duration,
    @Default(0) double distanceInKm,
    @Default(0) double speedInKmPerH,
    @Default(0) double avgSpeedInKmPerH,
    @Default([]) List<Coordinates> waypoints,
  }) = _DriveState;

  bool get haveDriveParamsBeenChanged =>
      duration.inSeconds > 0 ||
      distanceInKm > 0 ||
      avgSpeedInKmPerH > 0 ||
      waypoints.isNotEmpty;
}
