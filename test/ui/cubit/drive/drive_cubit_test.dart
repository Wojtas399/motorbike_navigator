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

class _Listener extends Mock {
  void call(DriveState state);
}

void main() {
  final locationService = MockLocationService();
  final mapService = MockMapService();
  final authRepository = MockAuthRepository();
  final driveRepository = MockDriveRepository();
  final dateService = MockDateService();
  final DateTime now = DateTime(2024, 1, 2, 10, 45);
  const Coordinates startLocation = Coordinates(50, 18);
  late DriveCubit cubit;

  setUp(() {
    dateService.mockGetNow(expectedNow: now);
    cubit = DriveCubit(
      locationService,
      mapService,
      authRepository,
      driveRepository,
      dateService,
    );
  });

  tearDown(() {
    reset(locationService);
    reset(mapService);
    reset(authRepository);
    reset(driveRepository);
    reset(dateService);
  });

  test(
    'startDrive, '
    'startLocation is null, '
    'should finish method call',
    () async {
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: null);

      verifyInOrder([]);
    },
  );

  test(
    'startDrive, '
    'should insert start location to waypoints, should set startDateTime as now, '
    'should start timer and should listen to position changes',
    () async {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          speedInKmPerH: 20,
        ),
        Position(
          coordinates: Coordinates(52.3, 20.3),
          speedInKmPerH: 25,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      const double secondDistanceBetweenPositions = 15;
      const double thirdDistanceBetweenPositions = 11.2;
      when(
        locationService.getPosition,
      ).thenAnswer((_) => positionStream$.stream);
      when(
        () => mapService.calculateDistanceInKm(
          location1: startLocation,
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
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
      positionStream$.add(positions.first);
      await Future.delayed(const Duration(seconds: 1));
      positionStream$.add(positions[1]);
      positionStream$.add(positions.last);
      await Future.delayed(const Duration(seconds: 2));

      DriveState state = const DriveState();
      verifyInOrder([
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            waypoints: [startLocation],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: positions.first.speedInKmPerH,
            distanceInKm: firstDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 1),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions[1].speedInKmPerH,
            avgSpeedInKmPerH: [
              positions.first.speedInKmPerH,
              positions[1].speedInKmPerH,
            ].average,
            distanceInKm:
                firstDistanceBetweenPositions + secondDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
              positions[1].coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.last.speedInKmPerH,
            avgSpeedInKmPerH: [
              positions.first.speedInKmPerH,
              positions[1].speedInKmPerH,
              positions.last.speedInKmPerH,
            ].average,
            distanceInKm: firstDistanceBetweenPositions +
                secondDistanceBetweenPositions +
                thirdDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
              positions[1].coordinates,
              positions.last.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 2),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 3),
          );
          listener(state);
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(locationService.getPosition).called(1);
    },
  );

  test(
    'pauseDrive, '
    'should stop timer and position listeners and should emit state with status '
    'set as paused',
    () async {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          speedInKmPerH: 20,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      when(
        locationService.getPosition,
      ).thenAnswer((_) => positionStream$.stream);
      when(
        () => mapService.calculateDistanceInKm(
          location1: startLocation,
          location2: positions.first.coordinates,
        ),
      ).thenReturn(firstDistanceBetweenPositions);
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
      positionStream$.add(positions.first);
      await Future.delayed(const Duration(seconds: 1));
      cubit.pauseDrive();
      positionStream$.add(positions[1]);
      await Future.delayed(const Duration(seconds: 2));

      DriveState state = const DriveState();
      verifyInOrder([
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            waypoints: [startLocation],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: positions.first.speedInKmPerH,
            distanceInKm: firstDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 1),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.paused,
          );
          listener(state);
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(locationService.getPosition).called(1);
    },
  );

  test(
    'resumeDrive, '
    'should resume timer and position listeners',
    () async {
      final positionStream$ = BehaviorSubject<Position>();
      final positionStream2$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
        ),
        Position(
          coordinates: Coordinates(51.2, 19.2),
          speedInKmPerH: 20,
        ),
        Position(
          coordinates: Coordinates(52.2, 20.2),
          speedInKmPerH: 11.2,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      const double secondDistanceBetweenPositions = 15;
      when(
        locationService.getPosition,
      ).thenAnswer((_) => positionStream$.stream);
      when(
        () => mapService.calculateDistanceInKm(
          location1: startLocation,
          location2: positions.first.coordinates,
        ),
      ).thenReturn(firstDistanceBetweenPositions);
      when(
        () => mapService.calculateDistanceInKm(
          location1: positions.first.coordinates,
          location2: positions.last.coordinates,
        ),
      ).thenReturn(secondDistanceBetweenPositions);
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
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
      await cubit.stream.first;

      DriveState state = const DriveState();
      verifyInOrder([
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            waypoints: [startLocation],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: positions.first.speedInKmPerH,
            distanceInKm: firstDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 1),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.paused,
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            duration: const Duration(seconds: 2),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.last.speedInKmPerH,
            avgSpeedInKmPerH: [
              positions.first.speedInKmPerH,
              positions.last.speedInKmPerH,
            ].average,
            distanceInKm:
                firstDistanceBetweenPositions + secondDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
              positions.last.coordinates,
            ],
          );
          listener(state);
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(locationService.getPosition).called(2);
    },
  );

  test(
    'saveDrive, '
    'drive is not paused, '
    'should do nothing',
    () async {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      when(
        locationService.getPosition,
      ).thenAnswer((_) => positionStream$.stream);
      when(
        () => mapService.calculateDistanceInKm(
          location1: startLocation,
          location2: positions.first.coordinates,
        ),
      ).thenReturn(firstDistanceBetweenPositions);
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
      positionStream$.add(positions.first);
      await Future.delayed(const Duration(seconds: 1));
      await cubit.saveDrive();

      DriveState state = const DriveState();
      verifyInOrder([
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            waypoints: [startLocation],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: positions.first.speedInKmPerH,
            distanceInKm: firstDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 1),
          );
          listener(state);
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(locationService.getPosition).called(1);
    },
  );

  test(
    'saveDrive, '
    'startDateTime is null, '
    'should do nothing',
    () async {
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.pauseDrive();
      await cubit.saveDrive();

      verifyInOrder([
        () => listener(
              const DriveState(
                status: DriveStateStatus.paused,
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'saveDrive, '
    'logged user does not exist, '
    'should throw exception',
    () async {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      const String expectedException = '[DriveCubit] Cannot find logged user';
      when(
        locationService.getPosition,
      ).thenAnswer((_) => positionStream$.stream);
      when(
        () => mapService.calculateDistanceInKm(
          location1: startLocation,
          location2: positions.first.coordinates,
        ),
      ).thenReturn(firstDistanceBetweenPositions);
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: null);
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
      positionStream$.add(positions.first);
      await Future.delayed(const Duration(seconds: 1));
      cubit.pauseDrive();
      await Future.delayed(const Duration(milliseconds: 500));
      Object? exception;
      try {
        await cubit.saveDrive();
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      DriveState state = const DriveState();
      verifyInOrder([
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            waypoints: [startLocation],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: positions.first.speedInKmPerH,
            distanceInKm: firstDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 1),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.paused,
          );
          listener(state);
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(locationService.getPosition).called(1);
    },
  );

  test(
    'saveDrive, '
    'should call method from DriveRepository to add new drive',
    () async {
      final positionStream$ = BehaviorSubject<Position>();
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50.1, 18.1),
          speedInKmPerH: 15,
        ),
      ];
      const double firstDistanceBetweenPositions = 5;
      when(
        locationService.getPosition,
      ).thenAnswer((_) => positionStream$.stream);
      when(
        () => mapService.calculateDistanceInKm(
          location1: startLocation,
          location2: positions.first.coordinates,
        ),
      ).thenReturn(firstDistanceBetweenPositions);
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: 'u1');
      driveRepository.mockAddDrive();
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
      positionStream$.add(positions.first);
      await Future.delayed(const Duration(seconds: 1));
      cubit.pauseDrive();
      await cubit.saveDrive();
      await Future.delayed(const Duration(milliseconds: 500));

      DriveState state = const DriveState();
      verifyInOrder([
        () {
          state = state.copyWith(
            status: DriveStateStatus.ongoing,
            startDatetime: now,
            waypoints: [startLocation],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            speedInKmPerH: positions.first.speedInKmPerH,
            avgSpeedInKmPerH: positions.first.speedInKmPerH,
            distanceInKm: firstDistanceBetweenPositions,
            waypoints: [
              startLocation,
              positions.first.coordinates,
            ],
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            duration: const Duration(seconds: 1),
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.paused,
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.saving,
          );
          listener(state);
        },
        () {
          state = state.copyWith(
            status: DriveStateStatus.saved,
          );
          listener(state);
        },
      ]);
      verifyNoMoreInteractions(listener);
      verify(locationService.getPosition).called(1);
      verify(
        () => driveRepository.addDrive(
          userId: 'u1',
          startDateTime: now,
          distanceInKm: firstDistanceBetweenPositions,
          duration: const Duration(seconds: 1),
          avgSpeedInKmPerH: positions.first.speedInKmPerH,
          waypoints: [
            startLocation,
            positions.first.coordinates,
          ],
        ),
      ).called(1);
    },
  );

  test(
    'resetDrive, '
    'should set default state',
    () async {
      locationService.mockGetPosition(expectedPosition: null);
      final listener = _Listener();
      cubit.stream.listen(listener.call);

      cubit.startDrive(startLocation: startLocation);
      cubit.resetDrive();
      await Future.delayed(const Duration(milliseconds: 500));

      verifyInOrder([
        () => listener.call(
              DriveState(
                status: DriveStateStatus.ongoing,
                startDatetime: now,
                waypoints: [startLocation],
              ),
            ),
        () => listener.call(const DriveState()),
      ]);
    },
  );
}
