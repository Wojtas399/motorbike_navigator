import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';

void main() {
  test(
    'default state',
    () {
      const DriveState expectedDefaultState = DriveState(
        status: DriveStateStatus.initial,
        startDatetime: null,
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
    'status.isInitial, '
    'should be true if status param is set as initial',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.initial);

      expect(state.status.isInitial, true);
    },
  );

  test(
    'status.isInitial, '
    'should be false if status param is set as ongoing',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.ongoing);

      expect(state.status.isInitial, false);
    },
  );

  test(
    'status.isInitial, '
    'should be false if status param is set as paused',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.paused);

      expect(state.status.isInitial, false);
    },
  );

  test(
    'status.isInitial, '
    'should be false if status param is set as saving',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.saving);

      expect(state.status.isInitial, false);
    },
  );

  test(
    'status.isInitial, '
    'should be false if status param is set as saved',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.saved);

      expect(state.status.isInitial, false);
    },
  );

  test(
    'status.isOngoing, '
    'should be true if status param is set as ongoing',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.ongoing);

      expect(state.status.isOngoing, true);
    },
  );

  test(
    'status.isOngoing, '
    'should be false if status param is set as initial',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.initial);

      expect(state.status.isOngoing, false);
    },
  );

  test(
    'status.isOngoing, '
    'should be false if status param is set as paused',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.paused);

      expect(state.status.isOngoing, false);
    },
  );

  test(
    'status.isOngoing, '
    'should be false if status param is set as saving',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.saving);

      expect(state.status.isOngoing, false);
    },
  );

  test(
    'status.isOngoing, '
    'should be false if status param is set as saved',
    () {
      const DriveState state = DriveState(status: DriveStateStatus.saved);

      expect(state.status.isOngoing, false);
    },
  );
}
