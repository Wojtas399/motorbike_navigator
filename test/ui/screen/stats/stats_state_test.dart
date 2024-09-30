import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/screen/stats/cubit/stats_state.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = StatsState(
        status: StatsStateStatus.loading,
        numberOfDrives: null,
        mileageInKm: null,
        totalDuration: null,
      );

      const defaultState = StatsState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'copyWith status, ',
    () {
      const StatsStateStatus expectedStatus = StatsStateStatus.completed;
      StatsState state = const StatsState();

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
    'copyWith numberOfDrives, ',
    () {
      const expectedNumberOfDrives = 12;
      StatsState state = const StatsState();

      test(
        'should update numberOfDrives if new value has been passed, ',
        () {
          state = state.copyWith(numberOfDrives: expectedNumberOfDrives);

          expect(state.numberOfDrives, expectedNumberOfDrives);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.numberOfDrives, expectedNumberOfDrives);
        },
      );

      test(
        'should set numberOfDrives as null if passed value is null',
        () {
          state = state.copyWith(numberOfDrives: null);

          expect(state.numberOfDrives, null);
        },
      );
    },
  );

  group(
    'copyWith mileageInKm, ',
    () {
      const expectedMileage = 125.22;
      StatsState state = const StatsState();

      test(
        'should update mileageInKm if new value has been passed, ',
        () {
          state = state.copyWith(mileageInKm: expectedMileage);

          expect(state.mileageInKm, expectedMileage);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.mileageInKm, expectedMileage);
        },
      );

      test(
        'should set mileageInKm as null if passed value is null',
        () {
          state = state.copyWith(mileageInKm: null);

          expect(state.mileageInKm, null);
        },
      );
    },
  );

  group(
    'copyWith totalDuration, ',
    () {
      const expectedTotalDuration = Duration(hours: 12, minutes: 33);
      StatsState state = const StatsState();

      test(
        'should update totalDuration if new value has been passed, ',
        () {
          state = state.copyWith(totalDuration: expectedTotalDuration);

          expect(state.totalDuration, expectedTotalDuration);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.totalDuration, expectedTotalDuration);
        },
      );

      test(
        'should set totalDuration as null if passed value is null',
        () {
          state = state.copyWith(totalDuration: null);

          expect(state.totalDuration, null);
        },
      );
    },
  );

  group(
    'copyWith mileageChartData, ',
    () {
      final expectedMileageChartData = [
        MileageChartData(
          date: DateTime(2024),
          value: 250.22,
        ),
        MileageChartData(
          date: DateTime(2024, 2),
          value: 270.66,
        ),
      ];
      StatsState state = const StatsState();

      test(
        'should update mileageChartData if new value has been passed, ',
        () {
          state = state.copyWith(mileageChartData: expectedMileageChartData);

          expect(state.mileageChartData, expectedMileageChartData);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.mileageChartData, expectedMileageChartData);
        },
      );

      test(
        'should set mileageOfChartData as null if passed value is null',
        () {
          state = state.copyWith(mileageChartData: null);

          expect(state.mileageChartData, null);
        },
      );
    },
  );
}
