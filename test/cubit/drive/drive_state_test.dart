import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';

void main() {
  test(
    'default state',
    () {
      const DriveState expectedDefaultState = DriveState(
        status: DriveStateStatus.initial,
        startDatetime: null,
        endDateTime: null,
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
}
