import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';

import '../../mock/ui_service/mock_location_service.dart';
import '../../mock/ui_service/mock_map_service.dart';

void main() {
  final locationService = MockLocationService();
  final mapService = MockMapService();
  DriveCubit createCubit() => DriveCubit(locationService, mapService);

  tearDown(() {
    reset(locationService);
    reset(mapService);
  });

  blocTest(
    'startDrive, '
    'startLocation is null, '
    'should finish method call',
    build: () => createCubit(),
    act: (cubit) => cubit.startDrive(startLocation: null),
    expect: () => [],
  );

  blocTest(
    'startDrive, '
    'should insert start location to waypoints, should start timer and should '
    'listen to position changes',
    build: () => createCubit(),
    setUp: () {
      when(
        locationService.getPosition,
      ).thenAnswer(
        (_) => Stream.fromIterable(
          const [
            Position(
              coordinates: Coordinates(50.1, 18.1),
              speedInMetersPerSecond: 15,
            ),
            Position(
              coordinates: Coordinates(51.2, 19.2),
              speedInMetersPerSecond: 20,
            ),
            Position(
              coordinates: Coordinates(52.3, 20.3),
              speedInMetersPerSecond: 25,
            ),
          ],
        ),
      );
      when(
        () => mapService.calculateDistanceInKm(
          location1: const Coordinates(50, 18),
          location2: const Coordinates(50.1, 18.1),
        ),
      ).thenReturn(5);
      when(
        () => mapService.calculateDistanceInKm(
          location1: const Coordinates(50.1, 18.1),
          location2: const Coordinates(51.2, 19.2),
        ),
      ).thenReturn(10);
      when(
        () => mapService.calculateDistanceInKm(
          location1: const Coordinates(51.2, 19.2),
          location2: const Coordinates(52.3, 20.3),
        ),
      ).thenReturn(20);
    },
    act: (cubit) async {
      cubit.startDrive(startLocation: const Coordinates(50, 18));
      await Future.delayed(
        const Duration(seconds: 2),
      );
    },
    expect: () => [
      const DriveState(
        status: DriveStateStatus.ongoing,
        waypoints: [
          Coordinates(50, 18),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        distanceInKm: 5,
        speedInKmPerH: 15 * 3.6,
        avgSpeedInKmPerH: 15 * 3.6,
        waypoints: [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        distanceInKm: 15,
        speedInKmPerH: 20 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6)) / 2,
        waypoints: [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        duration: Duration(seconds: 1),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        duration: Duration(seconds: 2),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
    ],
    verify: (_) {
      verify(locationService.getPosition).called(1);
      verify(
        () => mapService.calculateDistanceInKm(
          location1: any(named: 'location1'),
          location2: any(named: 'location2'),
        ),
      ).called(3);
    },
  );

  blocTest(
    'finishDrive, '
    'should emit status set as DriveStateStatus.finished',
    build: () => createCubit(),
    act: (cubit) => cubit.finishDrive(),
    expect: () => [
      const DriveState(
        status: DriveStateStatus.finished,
      ),
    ],
  );

  blocTest(
    'resetDrive, '
    'should set default state',
    build: () => createCubit(),
    setUp: () {
      locationService.mockGetPosition(expectedPosition: null);
    },
    act: (cubit) {
      cubit.startDrive(
        startLocation: const Coordinates(50, 18),
      );
      cubit.resetDrive();
    },
    expect: () => [
      const DriveState(
        status: DriveStateStatus.ongoing,
        waypoints: [
          Coordinates(50, 18),
        ],
      ),
      const DriveState(),
    ],
  );
}
