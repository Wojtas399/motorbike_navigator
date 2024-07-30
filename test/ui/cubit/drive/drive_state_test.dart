import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
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
        positions: [],
      );

      const state = DriveState();

      expect(state, expectedDefaultState);
    },
  );

  test(
    'get waypoints, '
    'should return coordinates got from positions',
    () {
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50, 19),
          altitude: 111.11,
          speedInKmPerH: 33.33,
        ),
        Position(
          coordinates: Coordinates(51, 20),
          altitude: 112.22,
          speedInKmPerH: 44.44,
        ),
        Position(
          coordinates: Coordinates(52, 21),
          altitude: 113.33,
          speedInKmPerH: 55.55,
        ),
      ];
      final Iterable<Coordinates> expectedWaypoints = positions.map(
        (Position position) => position.coordinates,
      );

      const DriveState state = DriveState(
        positions: positions,
      );

      expect(state.waypoints, expectedWaypoints);
    },
  );

  group(
    'copyWith status, ',
    () {
      const DriveStateStatus expectedStatus = DriveStateStatus.saving;
      DriveState state = const DriveState();

      test(
        'should update status if new value has been passed, ',
        () {
          state = state.copyWith(status: expectedStatus);

          expect(state.status, expectedStatus);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.status, expectedStatus);
        },
      );
    },
  );

  group(
    'copyWith startDateTime, ',
    () {
      final DateTime expectedStartDateTime = DateTime(2024, 07, 18);
      DriveState state = const DriveState();

      test(
        'should update startDateTime if new value has been passed',
        () {
          state = state.copyWith(startDatetime: expectedStartDateTime);

          expect(state.startDatetime, expectedStartDateTime);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.startDatetime, expectedStartDateTime);
        },
      );

      test(
        'should set startDateTime as null if passed value is null',
        () {
          state = state.copyWith(startDatetime: null);

          expect(state.startDatetime, null);
        },
      );
    },
  );

  group(
    'copyWith duration, ',
    () {
      const Duration expectedDuration = Duration(seconds: 5);
      DriveState state = const DriveState();

      test(
        'should update duration if new value has been passed, ',
        () {
          state = state.copyWith(duration: expectedDuration);

          expect(state.duration, expectedDuration);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.duration, expectedDuration);
        },
      );
    },
  );

  group(
    'copyWith distanceInKm, ',
    () {
      const double expectedDistanceInKm = 10.2;
      DriveState state = const DriveState();

      test(
        'should update distanceInKm if new value has been passed, ',
        () {
          state = state.copyWith(distanceInKm: expectedDistanceInKm);

          expect(state.distanceInKm, expectedDistanceInKm);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.distanceInKm, expectedDistanceInKm);
        },
      );
    },
  );

  group(
    'copyWith speedInKmPerH, ',
    () {
      const double expectedSpeedInKmPerH = 92.8;
      DriveState state = const DriveState();

      test(
        'should update speedInKmPerH if new value has been passed, ',
        () {
          state = state.copyWith(speedInKmPerH: expectedSpeedInKmPerH);

          expect(state.speedInKmPerH, expectedSpeedInKmPerH);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.speedInKmPerH, expectedSpeedInKmPerH);
        },
      );
    },
  );

  group(
    'copyWith avgSpeedInKmPerH, ',
    () {
      const double expectedAvgSpeedInKmPerH = 92.8;
      DriveState state = const DriveState();

      test(
        'should update avgSpeedInKmPerH if new value has been passed, ',
        () {
          state = state.copyWith(avgSpeedInKmPerH: expectedAvgSpeedInKmPerH);

          expect(state.avgSpeedInKmPerH, expectedAvgSpeedInKmPerH);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.avgSpeedInKmPerH, expectedAvgSpeedInKmPerH);
        },
      );
    },
  );

  group(
    'copyWith positions, ',
    () {
      const List<Position> expectedPositions = [
        Position(
          coordinates: Coordinates(50, 19),
          altitude: 111.11,
          speedInKmPerH: 55.55,
        ),
      ];
      DriveState state = const DriveState();

      test(
        'should update positions if new value has been passed, ',
        () {
          state = state.copyWith(positions: expectedPositions);

          expect(state.positions, expectedPositions);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.positions, expectedPositions);
        },
      );
    },
  );
}
