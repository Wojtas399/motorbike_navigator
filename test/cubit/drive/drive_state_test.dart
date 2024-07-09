import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';

void main() {
  test(
    'default state',
    () {
      const DriveState expectedDefaultState = DriveState(
        status: DriveStateStatus.initial,
        duration: Duration.zero,
        distanceInKm: 0,
        speedInKmPerH: 0,
        avgSpeedInKmPerH: 0,
        waypoints: [],
      );

      const state = DriveState();

      expect(state, expectedDefaultState);
    },
  );

  test(
    'haveDriveParamsBeenChanged, '
    'duration is higher than 0 seconds, '
    'should return true',
    () {
      const state = DriveState(
        duration: Duration(seconds: 1),
      );

      expect(state.haveDriveParamsBeenChanged, true);
    },
  );

  test(
    'haveDriveParamsBeenChanged, '
    'distance in km is longer than 0, '
    'should return true',
    () {
      const state = DriveState(
        distanceInKm: 0.1,
      );

      expect(state.haveDriveParamsBeenChanged, true);
    },
  );

  test(
    'haveDriveParamsBeenChanged, '
    'avg speed in km per h is higher than 0, '
    'should return true',
    () {
      const state = DriveState(
        avgSpeedInKmPerH: 0.01,
      );

      expect(state.haveDriveParamsBeenChanged, true);
    },
  );

  test(
    'haveDriveParamsBeenChanged, '
    'list of waypoints is not empty, '
    'should return true',
    () {
      const state = DriveState(
        waypoints: [
          Coordinates(50, 19),
        ],
      );

      expect(state.haveDriveParamsBeenChanged, true);
    },
  );

  test(
    'haveDriveParamsBeenChanged, '
    'all drive params are default, '
    'should return false',
    () {
      const state = DriveState();

      expect(state.haveDriveParamsBeenChanged, false);
    },
  );
}
