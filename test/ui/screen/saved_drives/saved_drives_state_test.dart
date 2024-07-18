import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_state.dart';

import '../../../creator/drive_creator.dart';

void main() {
  test(
    'default state, ',
    () {
      const SavedDrivesState expectedDefaultState = SavedDrivesState(
        status: SavedDrivesStateStatus.loading,
        drives: [],
      );

      const state = SavedDrivesState();

      expect(state, expectedDefaultState);
    },
  );

  group(
    'copyWith status, ',
    () {
      const expectedStatus = SavedDrivesStateStatus.completed;
      SavedDrivesState state = const SavedDrivesState();

      test(
        'should update status if new value has been passed, ',
        () {
          state = state.copyWith(status: expectedStatus);

          expect(state.status, expectedStatus);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.status, expectedStatus);
        },
      );
    },
  );

  group(
    'copyWith drives, ',
    () {
      final driveCreator = DriveCreator();
      final expectedDrives = <Drive>[
        driveCreator.create(id: 'd1'),
      ];
      SavedDrivesState state = const SavedDrivesState();

      test(
        'should update drives if new value has been passed, ',
        () {
          state = state.copyWith(drives: expectedDrives);

          expect(state.drives, expectedDrives);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.drives, expectedDrives);
        },
      );
    },
  );
}
