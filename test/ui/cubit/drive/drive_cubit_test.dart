import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';
import 'package:rxdart/rxdart.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_drive_repository.dart';
import '../../../mock/ui_service/mock_date_service.dart';
import '../../../mock/ui_service/mock_location_service.dart';
import '../../../mock/ui_service/mock_map_service.dart';

void main() {
  final locationService = MockLocationService();
  final mapService = MockMapService();
  final authRepository = MockAuthRepository();
  final driveRepository = MockDriveRepository();
  final dateService = MockDateService();
  final DateTime now = DateTime(2024, 1, 2, 10, 45);
  const Position startPosition = Position(
    coordinates: Coordinates(50, 18),
    altitude: 111.11,
    speedInKmPerH: 55.55,
  );

  DriveCubit createCubit() => DriveCubit(
        locationService,
        mapService,
        authRepository,
        driveRepository,
        dateService,
      );

  setUp(() {
    dateService.mockGetNow(expectedNow: now);
  });

  tearDown(() {
    reset(locationService);
    reset(mapService);
    reset(authRepository);
    reset(driveRepository);
    reset(dateService);
  });

  group(
    'startDrive, ',
    () {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
          altitude: 100.22,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          speedInKmPerH: 20,
          altitude: 101.22,
        ),
        Position(
          coordinates: Coordinates(52.3, 20.3),
          speedInKmPerH: 25,
          altitude: 102.22,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      const double secondDistanceBetweenPositions = 15;
      const double thirdDistanceBetweenPositions = 11.2;
      DriveState? state;

      blocTest(
        'should do nothing if startPosition is null, ',
        build: () => createCubit(),
        act: (cubit) => cubit.startDrive(startPosition: null),
        expect: () => [],
      );

      blocTest(
        'should insert start position to positions, should set startDateTime '
        'as now, should start timer and should listen to position changes',
        build: () => createCubit(),
        setUp: () {
          when(
            locationService.getPosition,
          ).thenAnswer((_) => positionStream$.stream);
          when(
            () => mapService.calculateDistanceInKm(
              location1: startPosition.coordinates,
              location2: positions.first.coordinates,
            ),
          ).thenReturn(firstDistanceBetweenPositions);
          when(
            () => mapService.calculateDistanceInKm(
              location1: positions.first.coordinates,
              location2: positions[1].coordinates,
            ),
          ).thenReturn(secondDistanceBetweenPositions);
          when(
            () => mapService.calculateDistanceInKm(
              location1: positions[1].coordinates,
              location2: positions.last.coordinates,
            ),
          ).thenReturn(thirdDistanceBetweenPositions);
        },
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          await Future.delayed(const Duration(seconds: 1));
          positionStream$.add(positions[1]);
          positionStream$.add(positions.last);
          await Future.delayed(const Duration(seconds: 1));
        },
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 1),
          ),
          state = state?.copyWith(
            speedInKmPerH: positions[1].speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
              positions[1].speedInKmPerH,
            ].average,
            distanceInKm:
                firstDistanceBetweenPositions + secondDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
              positions[1],
            ],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions[2].speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
              positions[1].speedInKmPerH,
              positions.last.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions +
                secondDistanceBetweenPositions +
                thirdDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
              positions[1],
              positions.last,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 2),
          ),
        ],
      );
    },
  );

  group(
    'pauseDrive, ',
    () {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          altitude: 100.22,
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          altitude: 101.22,
          speedInKmPerH: 20,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      DriveState? state;

      blocTest(
        'should stop timer and position listeners and should emit state with '
        'status set as paused',
        build: () => createCubit(),
        setUp: () {
          when(
            locationService.getPosition,
          ).thenAnswer((_) => positionStream$.stream);
          when(
            () => mapService.calculateDistanceInKm(
              location1: startPosition.coordinates,
              location2: positions.first.coordinates,
            ),
          ).thenReturn(firstDistanceBetweenPositions);
        },
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          await Future.delayed(const Duration(seconds: 1));
          cubit.pauseDrive();
          positionStream$.add(positions[1]);
          await Future.delayed(const Duration(seconds: 2));
        },
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 1),
          ),
          state = state?.copyWith(
            status: DriveStateStatus.paused,
          ),
        ],
      );
    },
  );

  group(
    'resumeDrive, ',
    () {
      final positionStream$ = BehaviorSubject<Position>();
      final positionStream2$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          altitude: 100.22,
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          altitude: 101.22,
          speedInKmPerH: 20,
        ),
        Position(
          coordinates: Coordinates(52.2, 20.2),
          altitude: 102.22,
          speedInKmPerH: 11.2,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      const double secondDistanceBetweenPositions = 15;
      DriveState? state;

      blocTest(
        'should resume timer and position listeners',
        build: () => createCubit(),
        setUp: () {
          when(
            locationService.getPosition,
          ).thenAnswer((_) => positionStream$.stream);
          when(
            () => mapService.calculateDistanceInKm(
              location1: startPosition.coordinates,
              location2: positions.first.coordinates,
            ),
          ).thenReturn(firstDistanceBetweenPositions);
          when(
            () => mapService.calculateDistanceInKm(
              location1: positions.first.coordinates,
              location2: positions.last.coordinates,
            ),
          ).thenReturn(secondDistanceBetweenPositions);
        },
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          await Future.delayed(const Duration(seconds: 1));
          cubit.pauseDrive();
          positionStream$.add(positions[1]);
          await Future.delayed(const Duration(seconds: 1));
          when(
            locationService.getPosition,
          ).thenAnswer((_) => positionStream2$.stream);
          cubit.resumeDrive();
          await Future.delayed(const Duration(milliseconds: 1500));
          positionStream2$.add(positions.last);
        },
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 1),
          ),
          state = state?.copyWith(
            status: DriveStateStatus.paused,
          ),
          state = state?.copyWith(
            status: DriveStateStatus.ongoing,
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 2),
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.last.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
              positions.last.speedInKmPerH,
            ].average,
            distanceInKm:
                firstDistanceBetweenPositions + secondDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
              positions.last,
            ],
          ),
        ],
      );
    },
  );

  group(
    'saveDrive, ',
    () {
      const String loggedUserId = 'u1';
      late BehaviorSubject<Position> positionStream$;
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          altitude: 100.22,
          speedInKmPerH: 15,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      DriveState? state;

      setUp(() {
        positionStream$ = BehaviorSubject<Position>();
        when(
          locationService.getPosition,
        ).thenAnswer((_) => positionStream$.stream);
        when(
          () => mapService.calculateDistanceInKm(
            location1: startPosition.coordinates,
            location2: positions.first.coordinates,
          ),
        ).thenReturn(firstDistanceBetweenPositions);
      });

      blocTest(
        'should do nothing if drive is not paused',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          await Future.delayed(const Duration(seconds: 1));
          await cubit.saveDrive();
        },
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 1),
          ),
        ],
      );

      blocTest(
        'should do nothing if startDateTime is null',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.pauseDrive();
          await cubit.saveDrive();
        },
        expect: () => [
          const DriveState(
            status: DriveStateStatus.paused,
          ),
        ],
      );

      blocTest(
        'should throw exception if logged user does not exist',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(expectedLoggedUserId: null);
        },
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          await Future.delayed(const Duration(seconds: 1));
          cubit.pauseDrive();
          await Future.delayed(const Duration(milliseconds: 500));
          await cubit.saveDrive();
        },
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 1),
          ),
          state = state?.copyWith(
            status: DriveStateStatus.paused,
          ),
        ],
        errors: () => [
          '[DriveCubit] Cannot find logged user',
        ],
      );

      blocTest(
        'should call method from DriveRepository to add new drive',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          driveRepository.mockAddDrive();
        },
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          await Future.delayed(const Duration(seconds: 1));
          cubit.pauseDrive();
          await cubit.saveDrive();
        },
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
          state = state?.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 1),
          ),
          state = state?.copyWith(
            status: DriveStateStatus.paused,
          ),
          state = state?.copyWith(
            status: DriveStateStatus.saving,
          ),
          state = state?.copyWith(
            status: DriveStateStatus.saved,
          ),
        ],
        verify: (_) {
          verify(
            () => driveRepository.addDrive(
              userId: loggedUserId,
              startDateTime: now,
              distanceInKm: firstDistanceBetweenPositions,
              duration: const Duration(seconds: 1),
              positions: [
                startPosition,
                ...positions,
              ],
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'resetDrive, '
    'should set default state',
    build: () => createCubit(),
    setUp: () => locationService.mockGetPosition(expectedPosition: null),
    act: (cubit) {
      cubit.startDrive(startPosition: startPosition);
      cubit.resetDrive();
    },
    expect: () => [
      DriveState(
        status: DriveStateStatus.ongoing,
        startDatetime: now,
        speedInKmPerH: startPosition.speedInKmPerH,
        avgSpeedInKmPerH: startPosition.speedInKmPerH,
        positions: [startPosition],
      ),
      const DriveState(),
    ],
  );
}
