import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
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
    'should start timer and should listen to current location and speed',
    build: () => createCubit(),
    setUp: () {
      when(
        () => locationService.getCurrentLocation(),
      ).thenAnswer(
        (_) => Stream.fromIterable(
          const [
            Coordinates(50.1, 18.1),
            Coordinates(51.2, 19.2),
            Coordinates(52.3, 20.3),
          ],
        ),
      );
      when(
        () => locationService.getCurrentSpeedInMetersPerHour(),
      ).thenAnswer(
        (_) => Stream.fromIterable(const [15, 20, 25]),
      );
      when(
        () => mapService.calculateDistanceInMeters(
          location1: const Coordinates(50.1, 18.1),
          location2: const Coordinates(50.1, 18.1),
        ),
      ).thenReturn(0);
      when(
        () => mapService.calculateDistanceInMeters(
          location1: const Coordinates(50.1, 18.1),
          location2: const Coordinates(51.2, 19.2),
        ),
      ).thenReturn(10);
      when(
        () => mapService.calculateDistanceInMeters(
          location1: const Coordinates(50.1, 18.1),
          location2: const Coordinates(52.3, 20.3),
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
        speedInKmPerH: 0.015,
        waypoints: [
          Coordinates(50.1, 18.1),
        ],
      ),
      const DriveState(
        distanceInMeters: 10,
        speedInKmPerH: 0.015,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
        ],
      ),
      const DriveState(
        distanceInMeters: 10,
        speedInKmPerH: 0.02,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
        ],
      ),
      const DriveState(
        distanceInMeters: 20,
        speedInKmPerH: 0.02,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        distanceInMeters: 20,
        speedInKmPerH: 0.025,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        durationInSeconds: 1,
        distanceInMeters: 20,
        speedInKmPerH: 0.025,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      const DriveState(
        durationInSeconds: 2,
        distanceInMeters: 20,
        speedInKmPerH: 0.025,
        waypoints: [
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
    ],
    verify: (_) {
      verify(locationService.getCurrentLocation).called(1);
      verify(locationService.getCurrentSpeedInMetersPerHour).called(1);
      verify(
        () => mapService.calculateDistanceInMeters(
          location1: any(named: 'location1'),
          location2: any(named: 'location2'),
        ),
      ).called(3);
    },
  );
}
