import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_cubit.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_state.dart';

import '../../../creator/drive_creator.dart';
import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_drive_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final driveRepository = MockDriveRepository();
  final driveCreator = DriveCreator();

  SavedDrivesCubit createCubit() => SavedDrivesCubit(
        authRepository,
        driveRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(driveRepository);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should throw exception',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [],
    errors: () => [
      '[SavedDrivesCubit] Cannot find logged user',
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'should listen to all user drives, sort them by startDateTime in descending '
    'order and should emit them',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: 'u1');
      when(
        () => driveRepository.getAllUserDrives(userId: 'u1'),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          [
            driveCreator.create(
              id: 'd1',
              startDateTime: DateTime(2024, 7, 13, 10, 30),
            ),
            driveCreator.create(
              id: 'd2',
              startDateTime: DateTime(2024, 7, 13, 12, 45),
            ),
          ],
          [
            driveCreator.create(
              id: 'd1',
              startDateTime: DateTime(2024, 7, 13, 10, 30),
            ),
            driveCreator.create(
              id: 'd2',
              startDateTime: DateTime(2024, 7, 13, 12, 45),
            ),
            driveCreator.create(
              id: 'd3',
              startDateTime: DateTime(2024, 7, 14, 9, 50),
            ),
          ],
        ]),
      );
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      SavedDrivesState(
        status: SavedDrivesStateStatus.completed,
        drives: [
          driveCreator.create(
            id: 'd2',
            startDateTime: DateTime(2024, 7, 13, 12, 45),
          ),
          driveCreator.create(
            id: 'd1',
            startDateTime: DateTime(2024, 7, 13, 10, 30),
          ),
        ],
      ),
      SavedDrivesState(
        status: SavedDrivesStateStatus.completed,
        drives: [
          driveCreator.create(
            id: 'd3',
            startDateTime: DateTime(2024, 7, 14, 9, 50),
          ),
          driveCreator.create(
            id: 'd2',
            startDateTime: DateTime(2024, 7, 13, 12, 45),
          ),
          driveCreator.create(
            id: 'd1',
            startDateTime: DateTime(2024, 7, 13, 10, 30),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authRepository.loggedUserId$).called(1);
      verify(
        () => driveRepository.getAllUserDrives(userId: 'u1'),
      ).called(1);
    },
  );
}
