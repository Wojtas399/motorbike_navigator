import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/ui/screen/drive_details/cubit/drive_details_state.dart';

import '../../../creator/drive_creator.dart';

void main() {
  group(
    'copyWith status, ',
    () {
      const DriveDetailsStateStatus expectedStatus =
          DriveDetailsStateStatus.completed;
      DriveDetailsState state = const DriveDetailsState();

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
    'copyWith drive, ',
    () {
      final Drive expectedDrive = DriveCreator(id: 1).createEntity();
      DriveDetailsState state = const DriveDetailsState();

      test(
        'should update drive if new value has been passed',
        () {
          state = state.copyWith(drive: expectedDrive);

          expect(state.drive, expectedDrive);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.drive, expectedDrive);
        },
      );

      test(
        'should set drive as null if passed value is null',
        () {
          state = state.copyWith(drive: null);

          expect(state.drive, null);
        },
      );
    },
  );

  group(
    'copyWith speedAreaChartData, ',
    () {
      const List<DriveDetailsDistanceAreaChartData> expectedData = [
        DriveDetailsDistanceAreaChartData(
          distance: 12.2,
          value: 50,
        ),
        DriveDetailsDistanceAreaChartData(
          distance: 24.4,
          value: 100,
        ),
      ];
      DriveDetailsState state = const DriveDetailsState();

      test(
        'should update speedAreaChartData if new value has been passed',
        () {
          state = state.copyWith(speedAreaChartData: expectedData);

          expect(state.speedAreaChartData, expectedData);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.speedAreaChartData, expectedData);
        },
      );

      test(
        'should set speedAreaChartData as null if passed value is null',
        () {
          state = state.copyWith(speedAreaChartData: null);

          expect(state.speedAreaChartData, null);
        },
      );
    },
  );

  group(
    'copyWith elevationAreaChartData, ',
    () {
      const List<DriveDetailsDistanceAreaChartData> expectedData = [
        DriveDetailsDistanceAreaChartData(
          distance: 12.2,
          value: 50,
        ),
        DriveDetailsDistanceAreaChartData(
          distance: 24.4,
          value: 100,
        ),
      ];
      DriveDetailsState state = const DriveDetailsState();

      test(
        'should update elevationAreaChartData if new value has been passed',
        () {
          state = state.copyWith(elevationAreaChartData: expectedData);

          expect(state.elevationAreaChartData, expectedData);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.elevationAreaChartData, expectedData);
        },
      );

      test(
        'should set elevationAreaChartData as null if passed value is null',
        () {
          state = state.copyWith(elevationAreaChartData: null);

          expect(state.elevationAreaChartData, null);
        },
      );
    },
  );
}
