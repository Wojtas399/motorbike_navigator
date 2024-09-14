import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/ui/cubit/date_range/date_range_cubit.dart';
import 'package:motorbike_navigator/ui/screen/stats/cubit/stats_cubit.dart';
import 'package:motorbike_navigator/ui/screen/stats/cubit/stats_state.dart';
import 'package:rxdart/rxdart.dart';

import '../../../creator/drive_creator.dart';
import '../../../mock/data/repository/mock_drive_repository.dart';
import '../../../mock/ui_service/mock_date_service.dart';

void main() {
  final driveRepository = MockDriveRepository();
  final dateService = MockDateService();

  StatsCubit createCubit() => StatsCubit(
        driveRepository,
        dateService,
      );

  tearDown(() {
    reset(driveRepository);
    reset(dateService);
  });

  group(
    'onDateRangeChanged, ',
    () {
      final WeeklyDateRange weeklyDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 22),
        lastDateOfRange: DateTime(2024, 7, 28),
      );
      final MonthlyDateRange monthlyDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 7),
        lastDateOfRange: DateTime(2024, 7, 31),
      );
      final YearlyDateRange yearlyDateRange = YearlyDateRange(
        firstDateOfRange: DateTime(2024),
        lastDateOfRange: DateTime(2024, 12, 31),
      );
      final List<Drive> weeklyDrives1 = [
        DriveCreator(
          startDateTime: DateTime(2024, 7, 23, 10, 35),
          distanceInKm: 52.30,
          duration: const Duration(minutes: 52, seconds: 33),
        ).createEntity(),
      ];
      final List<Drive> weeklyDrives2 = [
        weeklyDrives1.first,
        DriveCreator(
          startDateTime: DateTime(2024, 7, 23, 17, 15),
          distanceInKm: 52.30,
          duration: const Duration(minutes: 52, seconds: 33),
        ).createEntity(),
        DriveCreator(
          startDateTime: DateTime(2024, 7, 25, 23, 10),
          distanceInKm: 12.22,
          duration: const Duration(minutes: 15, seconds: 22),
        ).createEntity(),
      ];
      final List<Drive> monthlyDrives1 = [
        DriveCreator(
          startDateTime: DateTime(2024, 7, 2, 10, 30),
          distanceInKm: 22.22,
          duration: const Duration(minutes: 22, seconds: 22),
        ).createEntity(),
        DriveCreator(
          startDateTime: DateTime(2024, 7, 12, 11, 31),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 44),
        ).createEntity(),
        DriveCreator(
          startDateTime: DateTime(2024, 7, 30, 12, 32),
          distanceInKm: 55.55,
          duration: const Duration(minutes: 55, seconds: 55),
        ).createEntity(),
      ];
      final List<Drive> monthlyDrives2 = [
        monthlyDrives1.first,
        DriveCreator(
          startDateTime: DateTime(2024, 7, 2, 13, 13),
          distanceInKm: 33.33,
          duration: const Duration(minutes: 33, seconds: 33),
        ).createEntity(),
        monthlyDrives1[1],
        monthlyDrives1[2],
        DriveCreator(
          startDateTime: DateTime(2024, 7, 30, 14, 14),
          distanceInKm: 66.66,
          duration: const Duration(minutes: 59, seconds: 59),
        ).createEntity(),
      ];
      final List<Drive> yearlyDrives1 = [
        DriveCreator(
          startDateTime: DateTime(2024, 2, 2, 2, 2),
          distanceInKm: 22.22,
          duration: const Duration(minutes: 22, seconds: 22),
        ).createEntity(),
        DriveCreator(
          startDateTime: DateTime(2024, 3, 3, 3, 3),
          distanceInKm: 33.33,
          duration: const Duration(minutes: 33, seconds: 33),
        ).createEntity(),
        DriveCreator(
          startDateTime: DateTime(2024, 8, 8, 8, 8),
          distanceInKm: 88.88,
          duration: const Duration(hours: 1, minutes: 22, seconds: 22),
        ).createEntity(),
      ];
      final List<Drive> yearlyDrives2 = [
        yearlyDrives1.first,
        DriveCreator(
          startDateTime: DateTime(2024, 2, 12, 12, 12),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 44),
        ).createEntity(),
        yearlyDrives1[1],
        DriveCreator(
          startDateTime: DateTime(2024, 3, 23, 23, 23),
          distanceInKm: 66.66,
          duration: const Duration(hours: 1, minutes: 6, seconds: 46),
        ).createEntity(),
        DriveCreator(
          startDateTime: DateTime(2024, 3, 24, 20, 20),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 44),
        ).createEntity(),
        yearlyDrives1.last,
        DriveCreator(
          startDateTime: DateTime(2024, 12, 12, 12, 12),
          distanceInKm: 11.11,
          duration: const Duration(minutes: 11, seconds: 11),
        ).createEntity(),
      ];
      final expectedNumberOfWeeklyDrives1 = weeklyDrives1.length;
      final expectedNumberOfWeeklyDrives2 = weeklyDrives2.length;
      final expectedNumberOfMonthlyDrives1 = monthlyDrives1.length;
      final expectedNumberOfMonthlyDrives2 = monthlyDrives2.length;
      final expectedNumberOfYearlyDrives1 = yearlyDrives1.length;
      final expectedNumberOfYearlyDrives2 = yearlyDrives2.length;
      final expectedWeeklyMileage1 = _calculateMileage(weeklyDrives1);
      final expectedWeeklyMileage2 = _calculateMileage(weeklyDrives2);
      final expectedMonthlyMileage1 = _calculateMileage(monthlyDrives1);
      final expectedMonthlyMileage2 = _calculateMileage(monthlyDrives2);
      final expectedYearlyMileage1 = _calculateMileage(yearlyDrives1);
      final expectedYearlyMileage2 = _calculateMileage(yearlyDrives2);
      final expectedWeeklyDuration1 = _calculateTotalDuration(weeklyDrives1);
      final expectedWeeklyDuration2 = _calculateTotalDuration(weeklyDrives2);
      final expectedMonthlyDuration1 = _calculateTotalDuration(monthlyDrives1);
      final expectedMonthlyDuration2 = _calculateTotalDuration(monthlyDrives2);
      final expectedYearlyDuration1 = _calculateTotalDuration(yearlyDrives1);
      final expectedYearlyDuration2 = _calculateTotalDuration(yearlyDrives2);
      final List<MileageChartData> expectedWeeklyMileageChartData1 =
          List.generate(
        7,
        (int itemIndex) => MileageChartData(
          date: DateTime(2024, 7, 22 + itemIndex),
          value: itemIndex == 1 ? weeklyDrives1.first.distanceInKm : 0,
        ),
      );
      final List<MileageChartData> expectedWeeklyMileageChartData2 =
          List.generate(
        7,
        (int itemIndex) => MileageChartData(
          date: DateTime(2024, 7, 22 + itemIndex),
          value: switch (itemIndex) {
            1 =>
              weeklyDrives2.first.distanceInKm + weeklyDrives2[1].distanceInKm,
            3 => weeklyDrives2.last.distanceInKm,
            _ => 0,
          },
        ),
      );
      final List<MileageChartData> expectedMonthlyMileageChartData1 =
          List.generate(
        31,
        (int itemIndex) => MileageChartData(
          date: DateTime(2024, 7, itemIndex + 1),
          value: switch (itemIndex) {
            1 => monthlyDrives1.first.distanceInKm,
            11 => monthlyDrives1[1].distanceInKm,
            30 => monthlyDrives1[2].distanceInKm,
            _ => 0,
          },
        ),
      );
      final List<MileageChartData> expectedMonthlyMileageChartData2 =
          List.generate(
        31,
        (int itemIndex) => MileageChartData(
          date: DateTime(2024, 7, itemIndex + 1),
          value: switch (itemIndex) {
            1 => monthlyDrives2.first.distanceInKm +
                monthlyDrives2[1].distanceInKm,
            11 => monthlyDrives2[2].distanceInKm,
            30 =>
              monthlyDrives2[3].distanceInKm + monthlyDrives2.last.distanceInKm,
            _ => 0,
          },
        ),
      );
      final List<MileageChartData> expectedYearlyMileageChartData1 =
          List.generate(
        12,
        (int itemIndex) => MileageChartData(
          date: DateTime(2024, 1 + itemIndex),
          value: switch (itemIndex) {
            1 => yearlyDrives1.first.distanceInKm,
            2 => yearlyDrives1[1].distanceInKm,
            7 => yearlyDrives1.last.distanceInKm,
            _ => 0,
          },
        ),
      );
      final List<MileageChartData> expectedYearlyMileageChartData2 =
          List.generate(
        12,
        (int itemIndex) => MileageChartData(
          date: DateTime(2024, 1 + itemIndex),
          value: switch (itemIndex) {
            1 =>
              yearlyDrives2.first.distanceInKm + yearlyDrives2[1].distanceInKm,
            2 => yearlyDrives2[2].distanceInKm +
                yearlyDrives2[3].distanceInKm +
                yearlyDrives2[4].distanceInKm,
            7 => yearlyDrives2[5].distanceInKm,
            11 => yearlyDrives2.last.distanceInKm,
            _ => 0,
          },
        ),
      );
      final weeklyDrives$ = BehaviorSubject<List<Drive>>.seeded(weeklyDrives1);
      final monthlyDrives$ =
          BehaviorSubject<List<Drive>>.seeded(monthlyDrives1);
      final yearlyDrives$ = BehaviorSubject<List<Drive>>.seeded(yearlyDrives1);
      StatsState? state;

      blocTest(
        'should listen to drives from given date range and should prepare stats '
        'based on them, '
        'for weekly date range mileage chart data should contains elements '
        'represented each day of the week with values represented as sum of '
        'distance of all drives started in particular days',
        build: () => createCubit(),
        setUp: () {
          when(
            () => driveRepository.getDrivesFromDateRange(
              firstDateOfRange: weeklyDateRange.firstDateOfRange,
              lastDateOfRange: weeklyDateRange.lastDateOfRange,
            ),
          ).thenAnswer((_) => weeklyDrives$.stream);
          dateService.mockCalculateNumberOfDaysBetweenDatesInclusively(
            expectedNumberOfDays: 7,
          );
          dateService.mockAreDatesEqual(expectedAnswer: false);
          when(
            () => dateService.areDatesEqual(
              weeklyDrives2[0].startDateTime,
              weeklyDateRange.firstDateOfRange.add(const Duration(days: 1)),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesEqual(
              weeklyDrives2[1].startDateTime,
              weeklyDateRange.firstDateOfRange.add(const Duration(days: 1)),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesEqual(
              weeklyDrives2[2].startDateTime,
              weeklyDateRange.firstDateOfRange.add(const Duration(days: 3)),
            ),
          ).thenReturn(true);
        },
        act: (cubit) async {
          cubit.onDateRangeChanged(dateRange: weeklyDateRange);
          await cubit.stream.first;
          weeklyDrives$.add(weeklyDrives2);
        },
        expect: () => [
          state = StatsState(
            status: StatsStateStatus.completed,
            numberOfDrives: expectedNumberOfWeeklyDrives1,
            mileageInKm: expectedWeeklyMileage1,
            totalDuration: expectedWeeklyDuration1,
            mileageChartData: expectedWeeklyMileageChartData1,
          ),
          state = state?.copyWith(
            numberOfDrives: expectedNumberOfWeeklyDrives2,
            mileageInKm: expectedWeeklyMileage2,
            totalDuration: expectedWeeklyDuration2,
            mileageChartData: expectedWeeklyMileageChartData2,
          ),
        ],
        verify: (_) {
          verify(
            () => driveRepository.getDrivesFromDateRange(
              firstDateOfRange: weeklyDateRange.firstDateOfRange,
              lastDateOfRange: weeklyDateRange.lastDateOfRange,
            ),
          ).called(1);
          verify(
            () => dateService.calculateNumberOfDaysBetweenDatesInclusively(
              weeklyDateRange.firstDateOfRange,
              weeklyDateRange.lastDateOfRange,
            ),
          ).called(2);
        },
      );

      blocTest(
        'should listen to drives from given date range and should prepare stats '
        'based on them, '
        'for monthly date range mileage chart data should contains elements '
        'represented each day of the month with values represented as sum of '
        'distance of all drives started in particular days',
        build: () => createCubit(),
        setUp: () {
          when(
            () => driveRepository.getDrivesFromDateRange(
              firstDateOfRange: monthlyDateRange.firstDateOfRange,
              lastDateOfRange: monthlyDateRange.lastDateOfRange,
            ),
          ).thenAnswer((_) => monthlyDrives$.stream);
          dateService.mockCalculateNumberOfDaysBetweenDatesInclusively(
            expectedNumberOfDays: 31,
          );
          dateService.mockAreDatesEqual(expectedAnswer: false);
          when(
            () => dateService.areDatesEqual(
              monthlyDrives2[0].startDateTime,
              monthlyDateRange.firstDateOfRange.add(const Duration(days: 1)),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesEqual(
              monthlyDrives2[1].startDateTime,
              monthlyDateRange.firstDateOfRange.add(const Duration(days: 1)),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesEqual(
              monthlyDrives2[2].startDateTime,
              monthlyDateRange.firstDateOfRange.add(const Duration(days: 11)),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesEqual(
              monthlyDrives2[3].startDateTime,
              monthlyDateRange.firstDateOfRange.add(const Duration(days: 30)),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areDatesEqual(
              monthlyDrives2[4].startDateTime,
              monthlyDateRange.firstDateOfRange.add(const Duration(days: 30)),
            ),
          ).thenReturn(true);
        },
        act: (cubit) async {
          cubit.onDateRangeChanged(dateRange: monthlyDateRange);
          await cubit.stream.first;
          monthlyDrives$.add(monthlyDrives2);
        },
        expect: () => [
          state = StatsState(
            status: StatsStateStatus.completed,
            numberOfDrives: expectedNumberOfMonthlyDrives1,
            mileageInKm: expectedMonthlyMileage1,
            totalDuration: expectedMonthlyDuration1,
            mileageChartData: expectedMonthlyMileageChartData1,
          ),
          state = state?.copyWith(
            numberOfDrives: expectedNumberOfMonthlyDrives2,
            mileageInKm: expectedMonthlyMileage2,
            totalDuration: expectedMonthlyDuration2,
            mileageChartData: expectedMonthlyMileageChartData2,
          ),
        ],
        verify: (_) {
          verify(
            () => driveRepository.getDrivesFromDateRange(
              firstDateOfRange: monthlyDateRange.firstDateOfRange,
              lastDateOfRange: monthlyDateRange.lastDateOfRange,
            ),
          ).called(1);
          verify(
            () => dateService.calculateNumberOfDaysBetweenDatesInclusively(
              monthlyDateRange.firstDateOfRange,
              monthlyDateRange.lastDateOfRange,
            ),
          ).called(2);
        },
      );

      blocTest(
        'should listen to drives from given date range and should prepare stats '
        'based on them, '
        'for yearly date range mileage chart data should contains elements '
        'represented each month from date range with values represented as sum '
        'of distance of all drives started in particular months',
        build: () => createCubit(),
        setUp: () {
          when(
            () => driveRepository.getDrivesFromDateRange(
              firstDateOfRange: yearlyDateRange.firstDateOfRange,
              lastDateOfRange: yearlyDateRange.lastDateOfRange,
            ),
          ).thenAnswer((_) => yearlyDrives$.stream);
          dateService.mockAreMonthsEqual(expectedAnswer: false);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2[0].startDateTime,
              DateTime(2024, 2),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2[1].startDateTime,
              DateTime(2024, 2),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2[2].startDateTime,
              DateTime(2024, 3),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2[3].startDateTime,
              DateTime(2024, 3),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2[4].startDateTime,
              DateTime(2024, 3),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2[5].startDateTime,
              DateTime(2024, 8),
            ),
          ).thenReturn(true);
          when(
            () => dateService.areMonthsEqual(
              yearlyDrives2.last.startDateTime,
              DateTime(2024, 12),
            ),
          ).thenReturn(true);
        },
        act: (cubit) async {
          cubit.onDateRangeChanged(dateRange: yearlyDateRange);
          await cubit.stream.first;
          yearlyDrives$.add(yearlyDrives2);
        },
        expect: () => [
          state = StatsState(
            status: StatsStateStatus.completed,
            numberOfDrives: expectedNumberOfYearlyDrives1,
            mileageInKm: expectedYearlyMileage1,
            totalDuration: expectedYearlyDuration1,
            mileageChartData: expectedYearlyMileageChartData1,
          ),
          state = state?.copyWith(
            numberOfDrives: expectedNumberOfYearlyDrives2,
            mileageInKm: expectedYearlyMileage2,
            totalDuration: expectedYearlyDuration2,
            mileageChartData: expectedYearlyMileageChartData2,
          ),
        ],
        verify: (_) {
          verify(
            () => driveRepository.getDrivesFromDateRange(
              firstDateOfRange: yearlyDateRange.firstDateOfRange,
              lastDateOfRange: yearlyDateRange.lastDateOfRange,
            ),
          ).called(1);
        },
      );
    },
  );
}

double _calculateMileage(List<Drive> drives) =>
    drives.map((drive) => drive.distanceInKm).reduce(
          (totalDistance, driveDistance) => totalDistance + driveDistance,
        );

Duration _calculateTotalDuration(List<Drive> drives) =>
    drives.map((drive) => drive.duration).reduce(
          (totalDuration, driveDuration) => totalDuration + driveDuration,
        );
