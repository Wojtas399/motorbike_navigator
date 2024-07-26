import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/cubit/date_range/date_range_cubit.dart';

import '../../../mock/ui_service/mock_date_service.dart';

void main() {
  final dateService = MockDateService();

  DateRangeCubit createCubit() => DateRangeCubit(dateService);

  tearDown(() {
    reset(dateService);
  });

  group(
    'initializeWeeklyDateRange, ',
    () {
      final DateTime now = DateTime(2024, 7, 26);
      final DateTime firstDateOfTheWeek = DateTime(2024, 7, 22);
      final DateTime lastDateOfTheWeek = DateTime(2024, 7, 28);
      final WeeklyDateRange weeklyDateRange = WeeklyDateRange(
        firstDateOfRange: firstDateOfTheWeek,
        lastDateOfRange: lastDateOfTheWeek,
      );

      blocTest(
        'should set current week date range',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetFirstDateOfTheWeek(
            expectedFirstDateOfTheWeek: firstDateOfTheWeek,
          );
          dateService.mockGetLastDateOfTheWeek(
            expectedLastDateOfTheWeek: lastDateOfTheWeek,
          );
        },
        act: (cubit) => cubit.initializeWeeklyDateRange(),
        expect: () => [
          weeklyDateRange,
        ],
      );
    },
  );

  group(
    'changeToWeeklyDateRange, ',
    () {
      final DateTime now = DateTime(2024, 7, 26);
      final WeeklyDateRange weeklyDateRange1 = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 22),
        lastDateOfRange: DateTime(2024, 7, 28),
      );
      final MonthlyDateRange monthlyDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 7),
        lastDateOfRange: DateTime(2024, 7, 31),
      );
      final WeeklyDateRange weeklyDateRange2 = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7),
        lastDateOfRange: DateTime(2024, 7, 7),
      );

      blocTest(
        'should do nothing if current date range is not set',
        build: () => createCubit(),
        act: (cubit) => cubit.changeToWeeklyDateRange(),
        expect: () => [],
      );

      blocTest(
        'should change to weekly date range based on first date of current '
        'range',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetNow(expectedNow: now);
          when(
            () => dateService.getFirstDateOfTheWeek(now),
          ).thenReturn(weeklyDateRange1.firstDateOfRange);
          when(
            () => dateService.getLastDateOfTheWeek(now),
          ).thenReturn(weeklyDateRange1.lastDateOfRange);
          dateService.mockGetFirstDateOfTheMonth(
            expectedFirstDateOfTheMonth: monthlyDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheMonth(
            expectedLastDateOfTheMonth: monthlyDateRange.lastDateOfRange,
          );
          when(
            () => dateService.getFirstDateOfTheWeek(
              monthlyDateRange.firstDateOfRange,
            ),
          ).thenReturn(weeklyDateRange2.firstDateOfRange);
          when(
            () => dateService.getLastDateOfTheWeek(
              monthlyDateRange.firstDateOfRange,
            ),
          ).thenReturn(weeklyDateRange2.lastDateOfRange);
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToMonthlyDateRange();
          cubit.changeToWeeklyDateRange();
        },
        expect: () => [
          weeklyDateRange1,
          monthlyDateRange,
          weeklyDateRange2,
        ],
      );
    },
  );

  group(
    'changeToMonthlyDateRange, ',
    () {
      final DateTime now = DateTime(2024, 7, 26);
      final WeeklyDateRange weeklyDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 22),
        lastDateOfRange: DateTime(2024, 7, 28),
      );
      final MonthlyDateRange monthlyDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 7),
        lastDateOfRange: DateTime(2024, 7, 31),
      );

      blocTest(
        'should do nothing if current date range is not set',
        build: () => createCubit(),
        act: (cubit) => cubit.changeToMonthlyDateRange(),
        expect: () => [],
      );

      blocTest(
        'should change to monthly date range based on first date of current '
        'range',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetFirstDateOfTheWeek(
            expectedFirstDateOfTheWeek: weeklyDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheWeek(
            expectedLastDateOfTheWeek: weeklyDateRange.lastDateOfRange,
          );
          dateService.mockGetFirstDateOfTheMonth(
            expectedFirstDateOfTheMonth: monthlyDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheMonth(
            expectedLastDateOfTheMonth: monthlyDateRange.lastDateOfRange,
          );
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToMonthlyDateRange();
        },
        expect: () => [
          weeklyDateRange,
          monthlyDateRange,
        ],
      );
    },
  );

  group(
    'changeToYearlyDateRange, ',
    () {
      final DateTime now = DateTime(2024, 7, 26);
      final WeeklyDateRange weeklyDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 22),
        lastDateOfRange: DateTime(2024, 7, 28),
      );
      final YearlyDateRange yearlyDateRange = YearlyDateRange(
        firstDateOfRange: DateTime(2024),
        lastDateOfRange: DateTime(2024, 12, 31),
      );

      blocTest(
        'should do nothing if current date range is not set',
        build: () => createCubit(),
        act: (cubit) => cubit.changeToYearlyDateRange(),
        expect: () => [],
      );

      blocTest(
        'should change to yearly date range based on first date of current '
        'range',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetFirstDateOfTheWeek(
            expectedFirstDateOfTheWeek: weeklyDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheWeek(
            expectedLastDateOfTheWeek: weeklyDateRange.lastDateOfRange,
          );
          dateService.mockGetFirstDateOfTheYear(
            expectedFirstDateOfTheYear: yearlyDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheYear(
            expectedLastDateOfTheYear: yearlyDateRange.lastDateOfRange,
          );
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToYearlyDateRange();
        },
        expect: () => [
          weeklyDateRange,
          yearlyDateRange,
        ],
      );
    },
  );

  group(
    'previousDateRange, ',
    () {
      final DateTime now = DateTime(2024, 7, 26);
      final WeeklyDateRange currentWeekDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 22),
        lastDateOfRange: DateTime(2024, 7, 28),
      );
      final MonthlyDateRange currentMonthDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 7),
        lastDateOfRange: DateTime(2024, 7, 31),
      );
      final YearlyDateRange currentYearDateRange = YearlyDateRange(
        firstDateOfRange: DateTime(2024),
        lastDateOfRange: DateTime(2024, 12, 31),
      );
      final WeeklyDateRange previousWeekDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 15),
        lastDateOfRange: DateTime(2024, 7, 21),
      );
      final MonthlyDateRange previousMonthDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 6),
        lastDateOfRange: DateTime(2024, 6, 30),
      );
      final YearlyDateRange previousYearDateRange = YearlyDateRange(
        firstDateOfRange: DateTime(2023),
        lastDateOfRange: DateTime(2023, 12, 31),
      );

      setUp(() {
        dateService.mockGetNow(expectedNow: now);
        dateService.mockGetFirstDateOfTheWeek(
          expectedFirstDateOfTheWeek: currentWeekDateRange.firstDateOfRange,
        );
        dateService.mockGetLastDateOfTheWeek(
          expectedLastDateOfTheWeek: currentWeekDateRange.lastDateOfRange,
        );
      });

      blocTest(
        'should do nothing if date range is not set',
        build: () => createCubit(),
        act: (cubit) => cubit.previousDateRange(),
        expect: () => [],
      );

      blocTest(
        'should set previous week date range if current range is of type '
        'WeeklyDateRange',
        build: () => createCubit(),
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.previousDateRange();
        },
        expect: () => [
          currentWeekDateRange,
          previousWeekDateRange,
        ],
      );

      blocTest(
        'should set previous month date range if current range is of type '
        'MonthlyDateRange',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetFirstDateOfTheMonth(
            expectedFirstDateOfTheMonth: currentMonthDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheMonth(
            expectedLastDateOfTheMonth: currentMonthDateRange.lastDateOfRange,
          );
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToMonthlyDateRange();
          cubit.previousDateRange();
        },
        expect: () => [
          currentWeekDateRange,
          currentMonthDateRange,
          previousMonthDateRange,
        ],
      );

      blocTest(
        'should set previous year date range if current range is of type '
        'YearlyDateRange',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetFirstDateOfTheYear(
            expectedFirstDateOfTheYear: currentYearDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheYear(
            expectedLastDateOfTheYear: currentYearDateRange.lastDateOfRange,
          );
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToYearlyDateRange();
          cubit.previousDateRange();
        },
        expect: () => [
          currentWeekDateRange,
          currentYearDateRange,
          previousYearDateRange,
        ],
      );
    },
  );

  group(
    'nextDateRange, ',
    () {
      final DateTime now = DateTime(2024, 7, 26);
      final WeeklyDateRange currentWeekDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 22),
        lastDateOfRange: DateTime(2024, 7, 28),
      );
      final MonthlyDateRange currentMonthDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 7),
        lastDateOfRange: DateTime(2024, 7, 31),
      );
      final YearlyDateRange currentYearDateRange = YearlyDateRange(
        firstDateOfRange: DateTime(2024),
        lastDateOfRange: DateTime(2024, 12, 31),
      );
      final WeeklyDateRange nextWeekDateRange = WeeklyDateRange(
        firstDateOfRange: DateTime(2024, 7, 29),
        lastDateOfRange: DateTime(2024, 8, 4),
      );
      final MonthlyDateRange nextMonthDateRange = MonthlyDateRange(
        firstDateOfRange: DateTime(2024, 8),
        lastDateOfRange: DateTime(2024, 8, 31),
      );
      final YearlyDateRange nextYearDateRange = YearlyDateRange(
        firstDateOfRange: DateTime(2025),
        lastDateOfRange: DateTime(2025, 12, 31),
      );

      setUp(() {
        dateService.mockGetNow(expectedNow: now);
        dateService.mockGetFirstDateOfTheWeek(
          expectedFirstDateOfTheWeek: currentWeekDateRange.firstDateOfRange,
        );
        dateService.mockGetLastDateOfTheWeek(
          expectedLastDateOfTheWeek: currentWeekDateRange.lastDateOfRange,
        );
      });

      blocTest(
        'should do nothing if date range is not set',
        build: () => createCubit(),
        act: (cubit) => cubit.nextDateRange(),
        expect: () => [],
      );

      blocTest(
        'should set next week date range if current range is of type '
        'WeeklyDateRange',
        build: () => createCubit(),
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.nextDateRange();
        },
        expect: () => [
          currentWeekDateRange,
          nextWeekDateRange,
        ],
      );

      blocTest(
        'should set next month date range if current range is of type '
        'MonthlyDateRange',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetFirstDateOfTheMonth(
            expectedFirstDateOfTheMonth: currentMonthDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheMonth(
            expectedLastDateOfTheMonth: currentMonthDateRange.lastDateOfRange,
          );
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToMonthlyDateRange();
          cubit.nextDateRange();
        },
        expect: () => [
          currentWeekDateRange,
          currentMonthDateRange,
          nextMonthDateRange,
        ],
      );

      blocTest(
        'should set next year date range if current range is of type '
        'YearlyDateRange',
        build: () => createCubit(),
        setUp: () {
          dateService.mockGetFirstDateOfTheYear(
            expectedFirstDateOfTheYear: currentYearDateRange.firstDateOfRange,
          );
          dateService.mockGetLastDateOfTheYear(
            expectedLastDateOfTheYear: currentYearDateRange.lastDateOfRange,
          );
        },
        act: (cubit) {
          cubit.initializeWeeklyDateRange();
          cubit.changeToYearlyDateRange();
          cubit.nextDateRange();
        },
        expect: () => [
          currentWeekDateRange,
          currentYearDateRange,
          nextYearDateRange,
        ],
      );
    },
  );
}
