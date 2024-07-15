import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_cubit.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_state.dart';
import 'package:rxdart/rxdart.dart';

import '../../../creator/drive_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_drive_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final driveRepository = MockDriveRepository();
  final driveCreator = DriveCreator();
  late SavedDrivesCubit cubit;

  setUp(() {
    cubit = SavedDrivesCubit(
      authRepository,
      driveRepository,
    );
  });

  tearDown(() {
    reset(authRepository);
    reset(driveRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => SavedDrivesCubit(
      authRepository,
      driveRepository,
    ),
    setUp: () => authRepository.mockGetLoggedUserId(expectedLoggedUserId: null),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
  );

  test(
    'initialize, '
    'should listen to all user drives, sort them by startDateTime in descending '
    'order and should emit them',
    () async {
      const String loggedUserId = 'u1';
      final List<Drive> drives1 = [
        driveCreator.create(
          id: 'd1',
          startDateTime: DateTime(2024, 7, 13, 10, 30),
        ),
        driveCreator.create(
          id: 'd2',
          startDateTime: DateTime(2024, 7, 13, 12, 45),
        ),
      ];
      final List<Drive> drives2 = [
        ...drives1,
        driveCreator.create(
          id: 'd3',
          startDateTime: DateTime(2024, 7, 14, 9, 50),
        ),
      ];
      final List<SavedDrivesState> expectedEmittedStates = [
        SavedDrivesState(
          status: SavedDrivesStateStatus.completed,
          drives: [
            drives1.last,
            drives1.first,
          ],
        ),
        SavedDrivesState(
          status: SavedDrivesStateStatus.completed,
          drives: [
            drives2.last,
            drives2[1],
            drives2.first,
          ],
        ),
      ];
      final drivesStream$ = BehaviorSubject<List<Drive>>();
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: loggedUserId);
      when(
        () => driveRepository.getAllUserDrives(userId: loggedUserId),
      ).thenAnswer((_) => drivesStream$.stream);
      final List<SavedDrivesState> emittedStates = [];

      cubit.initialize();
      drivesStream$.add(drives1);
      emittedStates.add(await cubit.stream.first);
      drivesStream$.add(drives2);
      emittedStates.add(await cubit.stream.first);

      expect(emittedStates, expectedEmittedStates);
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => driveRepository.getAllUserDrives(userId: 'u1'),
      ).called(1);
    },
  );
}
