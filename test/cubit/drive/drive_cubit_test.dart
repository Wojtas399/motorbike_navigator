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
    'should start timer and should listen to current position',
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
        () => mapService.calculateDistanceInMeters(
          location1: const Coordinates(51.2, 19.2),
          location2: const Coordinates(50.1, 18.1),
        ),
      ).thenReturn(10);
      when(
        () => mapService.calculateDistanceInMeters(
          location1: const Coordinates(52.3, 20.3),
          location2: const Coordinates(51.2, 19.2),
        ),
      ).thenReturn(20);
    },
    act: (cubit) async {
      await cubit.startDrive();
      await Future.delayed(
        const Duration(seconds: 2),
      );
    },
    expect: () => [
      const DriveState(
        status: DriveStateStatus.ongoing,
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        speedInKmPerH: 15 * 3.6,
        waypoints: [
          Coordinates(50.1, 18.1),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        distanceInMeters: 10,
        speedInKmPerH: 20 * 3.6,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        distanceInMeters: 30,
        speedInKmPerH: 25 * 3.6,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        durationInSeconds: 1,
        distanceInMeters: 30,
        speedInKmPerH: 25 * 3.6,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        status: DriveStateStatus.ongoing,
        durationInSeconds: 2,
        distanceInMeters: 30,
        speedInKmPerH: 25 * 3.6,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
    ],
    verify: (_) {
      verify(locationService.getPosition).called(1);
      verify(
        () => mapService.calculateDistanceInMeters(
          location1: any(named: 'location1'),
          location2: any(named: 'location2'),
        ),
      ).called(2);
    },
  );
}
