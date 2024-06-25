import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/coordinates.dart';

part 'drive_state.freezed.dart';

enum DriveStateStatus { initial, ongoing }

@freezed
class DriveState with _$DriveState {
  const factory DriveState({
    @Default(DriveStateStatus.initial) DriveStateStatus status,
    @Default(0) double durationInSeconds,
    @Default(0) double distanceInMeters,
    @Default(0) double speedInKmPerH,
    List<Coordinates>? waypoints,
  }) = _DriveState;
}
