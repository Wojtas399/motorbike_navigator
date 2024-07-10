import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';

import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_drive_repository.dart';
import '../../mock/ui_service/mock_date_service.dart';
import '../../mock/ui_service/mock_location_service.dart';
import '../../mock/ui_service/mock_map_service.dart';

void main() {
  final locationService = MockLocationService();
  final mapService = MockMapService();
  final authRepository = MockAuthRepository();
  final driveRepository = MockDriveRepository();
  final dateService = MockDateService();
  DriveCubit createCubit() => DriveCubit(
        locationService,
        mapService,
        authRepository,
        driveRepository,
        dateService,
      );

  tearDown(() {
    reset(locationService);
    reset(mapService);
    reset(authRepository);
    reset(driveRepository);
    reset(dateService);
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
    'should insert start location to waypoints, should set startDateTime as now, '
    'should start timer and should listen to position changes',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        expectedNow: DateTime(2024, 1, 2, 10, 45),
      );
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
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        waypoints: const [
          Coordinates(50, 18),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 5,
        speedInKmPerH: 15 * 3.6,
        avgSpeedInKmPerH: 15 * 3.6,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 15,
        speedInKmPerH: 20 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6)) / 2,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 2),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
    ],
    verify: (_) {
      verify(dateService.getNow).called(1);
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
    'should stop timer and position listeners and should emit state with status '
    'set as finished and endDateTime set as now',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        expectedNow: DateTime(2024, 1, 2, 10, 45),
      );
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
        const Duration(seconds: 1),
      );
      cubit.finishDrive();
      await Future.delayed(
        const Duration(seconds: 1),
      );
    },
    expect: () => [
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        waypoints: const [
          Coordinates(50, 18),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 5,
        speedInKmPerH: 15 * 3.6,
        avgSpeedInKmPerH: 15 * 3.6,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 15,
        speedInKmPerH: 20 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6)) / 2,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
      DriveState(
        status: DriveStateStatus.finished,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 35,
        speedInKmPerH: 25 * 3.6,
        avgSpeedInKmPerH: ((15 * 3.6) + (20 * 3.6) + (25 * 3.6)) / 3,
        waypoints: const [
          Coordinates(50, 18),
          Coordinates(50.1, 18.1),
          Coordinates(51.2, 19.2),
          Coordinates(52.3, 20.3),
        ],
      ),
    ],
    verify: (_) {
      verify(dateService.getNow).called(1);
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
    'saveDrive, '
    'drive is not finished, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        expectedNow: DateTime(2024, 1, 2, 10, 45),
      );
      locationService.mockGetPosition(
        expectedPosition: const Position(
          coordinates: Coordinates(50, 19),
          speedInMetersPerSecond: 50,
        ),
      );
      mapService.mockCalculateDistanceInKm(
        expectedDistance: 10,
      );
    },
    act: (cubit) async {
      cubit.startDrive(
        startLocation: const Coordinates(49, 18),
      );
      await cubit.saveDrive();
    },
    expect: () => [
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        waypoints: const [Coordinates(49, 18)],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
    ],
  );

  blocTest(
    'saveDrive, '
    'logged user does not exist, '
    'should throw exception',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        expectedNow: DateTime(2024, 1, 2, 10, 45),
      );
      locationService.mockGetPosition(
        expectedPosition: const Position(
          coordinates: Coordinates(50, 19),
          speedInMetersPerSecond: 50,
        ),
      );
      mapService.mockCalculateDistanceInKm(
        expectedDistance: 10,
      );
      authRepository.mockGetLoggedUserId();
    },
    act: (cubit) async {
      cubit.startDrive(
        startLocation: const Coordinates(49, 18),
      );
      await Future.delayed(const Duration(seconds: 1));
      cubit.finishDrive();
      await cubit.saveDrive();
    },
    expect: () => [
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        waypoints: const [Coordinates(49, 18)],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
      DriveState(
        status: DriveStateStatus.finished,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
    ],
    errors: () => [
      '[DriveCubit] Cannot find logged user',
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'saveDrive, '
    'should call method from DriveRepository to add new drive',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        expectedNow: DateTime(2024, 1, 2, 10, 45),
      );
      locationService.mockGetPosition(
        expectedPosition: const Position(
          coordinates: Coordinates(50, 19),
          speedInMetersPerSecond: 50,
        ),
      );
      mapService.mockCalculateDistanceInKm(
        expectedDistance: 10,
      );
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: 'u1');
      driveRepository.mockAddDrive();
    },
    act: (cubit) async {
      cubit.startDrive(
        startLocation: const Coordinates(49, 18),
      );
      await Future.delayed(const Duration(seconds: 1));
      cubit.finishDrive();
      await cubit.saveDrive();
    },
    expect: () => [
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        waypoints: const [Coordinates(49, 18)],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
      DriveState(
        status: DriveStateStatus.finished,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
      DriveState(
        status: DriveStateStatus.saving,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
      DriveState(
        status: DriveStateStatus.saved,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        duration: const Duration(seconds: 1),
        distanceInKm: 10,
        speedInKmPerH: 50 * 3.6,
        avgSpeedInKmPerH: 50 * 3.6,
        waypoints: const [
          Coordinates(49, 18),
          Coordinates(50, 19),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => driveRepository.addDrive(
          userId: 'u1',
          startDateTime: DateTime(2024, 7, 10, 9, 28),
          distanceInKm: 10,
          durationInSeconds: 1,
          avgSpeedInKmPerH: 50 * 3.6,
          waypoints: const [
            Coordinates(49, 18),
            Coordinates(50, 19),
          ],
        ),
      ).called(1);
    },
  );

  blocTest(
    'resetDrive, '
    'should set default state',
    build: () => createCubit(),
    setUp: () {
      dateService.mockGetNow(
        expectedNow: DateTime(2024, 1, 2, 10, 45),
      );
      locationService.mockGetPosition(expectedPosition: null);
    },
    act: (cubit) {
      cubit.startDrive(
        startLocation: const Coordinates(50, 18),
      );
      cubit.resetDrive();
    },
    expect: () => [
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: DateTime(2024, 1, 2, 10, 45),
        waypoints: const [
          Coordinates(50, 18),
        ],
      ),
      const DriveState(),
    ],
  );
}
