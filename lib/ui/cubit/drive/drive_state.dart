import 'package:freezed_annotation/freezed_annotation.dart';

part 'drive_state.freezed.dart';

@freezed
class DriveState with _$DriveState {
  const factory DriveState({
    @Default(0) double durationInSeconds,
    @Default(0) double distanceInMeters,
    @Default(0) double speedInKmPerH,
  }) = _DriveState;
}
