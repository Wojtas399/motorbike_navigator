import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/drive/drive_state.dart';
import 'package:motorbike_navigator/ui/service/location_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../mock/data/repository/mock_drive_repository.dart';
import '../../../mock/ui_service/mock_date_service.dart';
import '../../../mock/ui_service/mock_location_service.dart';
import '../../../mock/ui_service/mock_map_service.dart';

void main() {
  final locationService = MockLocationService();
  final mapService = MockMapService();
  final driveRepository = MockDriveRepository();
  final dateService = MockDateService();
  final DateTime now = DateTime(2024, 1, 2, 10, 45);
  const Position startPosition = Position(
    coordinates: Coordinates(50, 18),
    elevation: 111.11,
    speedInKmPerH: 55.55,
  );

  DriveCubit createCubit() => DriveCubit(
        locationService,
        mapService,
        driveRepository,
        dateService,
      );

  setUp(() {
    dateService.mockGetNow(expectedNow: now);
  });

  tearDown(() {
    reset(locationService);
    reset(mapService);
    reset(driveRepository);
    reset(dateService);
  });

  group(
    'startDrive, ',
    () {
      final positionStream$ = BehaviorSubject<Position?>();
      final locationStatusStream$ = BehaviorSubject<LocationStatus>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
          elevation: 100.22,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          speedInKmPerH: 20,
          elevation: 101.22,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      const double secondDistanceBetweenPositions = 15;
      DriveState? state;

      setUp(() {
        when(
          locationService.getPosition,
        ).thenAnswer((_) => const Stream.empty());
        when(
          locationService.getLocationStatus,
        ).thenAnswer((_) => const Stream.empty());
      });

      blocTest(
        'should do nothing if startPosition is null, ',
        build: () => createCubit(),
        act: (cubit) => cubit.startDrive(startPosition: null),
        expect: () => [],
      );

      blocTest(
        'should insert start position to positions and should set startDateTime '
        'as now',
        build: () => createCubit(),
        act: (cubit) => cubit.startDrive(startPosition: startPosition),
        expect: () => [
          state = DriveState(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            speedInKmPerH: startPosition.speedInKmPerH,
            avgSpeedInKmPerH: startPosition.speedInKmPerH,
            positions: [startPosition],
          ),
        ],
      );

      blocTest(
        'should start timer',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          await Future.delayed(
            const Duration(seconds: 2),
          );
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
            duration: const Duration(seconds: 1),
          ),
          state = state?.copyWith(
            duration: const Duration(seconds: 2),
          ),
        ],
      );

      blocTest(
        'should listen to position change',
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
        },
        act: (cubit) {
          cubit.startDrive(startPosition: startPosition);
          positionStream$.add(positions.first);
          positionStream$.add(null);
          positionStream$.add(positions[1]);
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
            distanceInKm: firstDistanceBetweenPositions,
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
            ].average,
            positions: [
              startPosition,
              positions.first,
            ],
          ),
          state = state?.copyWith(
            distanceInKm:
                firstDistanceBetweenPositions + secondDistanceBetweenPositions,
            speedInKmPerH: positions[1].speedInKmPerH,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              positions.first.speedInKmPerH,
              positions[1].speedInKmPerH,
            ].average,
            positions: [
              startPosition,
              positions.first,
              positions[1],
            ],
          ),
        ],
      );

      blocTest(
        'should listen to location status change and should pause drive if '
        'location is off and drive status is set as ongoing',
        build: () => createCubit(),
        setUp: () => when(
          locationService.getLocationStatus,
        ).thenAnswer((_) => locationStatusStream$.stream),
        act: (cubit) {
          cubit.startDrive(startPosition: startPosition);
          locationStatusStream$.add(LocationStatus.off);
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
            status: DriveStateStatus.paused,
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
          elevation: 100.22,
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          elevation: 101.22,
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
          locationService.mockGetLocationStatus(
            expectedLocationStatus: LocationStatus.on,
          );
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
          elevation: 100.22,
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          elevation: 101.22,
          speedInKmPerH: 20,
        ),
        Position(
          coordinates: Coordinates(52.2, 20.2),
          elevation: 102.22,
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
          locationService.mockGetLocationStatus(
            expectedLocationStatus: LocationStatus.on,
          );
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
      late BehaviorSubject<Position> positionStream$;
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          elevation: 100.22,
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
        locationService.mockGetLocationStatus(
          expectedLocationStatus: LocationStatus.on,
        );
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
        'should call method from DriveRepository to add new drive',
        build: () => createCubit(),
        setUp: () => driveRepository.mockAddDrive(),
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

  group(
    'resetDrive, ',
    () {
      const position = Position(
        coordinates: Coordinates(50, 19),
        elevation: 100.1,
        speedInKmPerH: 22.22,
      );
      DriveState? state;

      blocTest(
        'resetDrive, '
        'should set default state',
        build: () => createCubit(),
        setUp: () {
          locationService.mockGetPosition(expectedPosition: position);
          locationService.mockGetLocationStatus(
            expectedLocationStatus: LocationStatus.on,
          );
          mapService.mockCalculateDistanceInKm(expectedDistance: 10.10);
        },
        act: (cubit) async {
          cubit.startDrive(startPosition: startPosition);
          await cubit.stream.first;
          cubit.resetDrive();
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
            distanceInKm: 10.10,
            speedInKmPerH: 22.22,
            avgSpeedInKmPerH: [
              startPosition.speedInKmPerH,
              22.22,
            ].average,
            positions: [
              startPosition,
              position,
            ],
          ),
          const DriveState(),
        ],
      );
    },
  );
}
