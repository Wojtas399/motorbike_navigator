import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_cubit.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_state.dart';
import 'package:rxdart/rxdart.dart';

import '../../../creator/drive_creator.dart';
import '../../../mock/data/repository/mock_drive_repository.dart';

void main() {
  final driveRepository = MockDriveRepository();

  SavedDrivesCubit createCubit() => SavedDrivesCubit(driveRepository);

  tearDown(() {
    reset(driveRepository);
  });

  group(
    'initialize, ',
    () {
      final List<Drive> drives1 = [
        DriveCreator(
          id: 1,
          startDateTime: DateTime(2024, 7, 13, 10, 30),
        ).createEntity(),
        DriveCreator(
          id: 2,
          startDateTime: DateTime(2024, 7, 13, 12, 45),
        ).createEntity(),
      ];
      final List<Drive> drives2 = [
        ...drives1,
        DriveCreator(
          id: 3,
          startDateTime: DateTime(2024, 7, 14, 9, 50),
        ).createEntity(),
      ];
      final drivesStream$ = BehaviorSubject<List<Drive>>();
      SavedDrivesState? state;

      blocTest(
        'should listen to all drives, sort them by startDateTime in descending '
        'order and should emit them',
        build: () => createCubit(),
        setUp: () => when(
          () => driveRepository.getAllDrives(),
        ).thenAnswer((_) => drivesStream$.stream),
        act: (cubit) async {
          cubit.initialize();
          drivesStream$.add(drives1);
          await cubit.stream.first;
          drivesStream$.add(drives2);
        },
        expect: () => [
          state = SavedDrivesState(
            status: SavedDrivesStateStatus.completed,
            drives: [
              drives1.last,
              drives1.first,
            ],
          ),
          state = state?.copyWith(
            drives: [
              drives2.last,
              drives2[1],
              drives2.first,
            ],
          ),
        ],
        verify: (_) => verify(driveRepository.getAllDrives).called(1),
      );
    },
  );
}
