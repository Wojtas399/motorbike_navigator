import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/screen/saved_drives/cubit/saved_drives_state.dart';

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
}
