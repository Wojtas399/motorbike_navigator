import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/service/date_range_service.dart';

import '../../mock/ui_service/mock_date_service.dart';

void main() {
  final dateService = MockDateService();

  final service = DateRangeService(dateService);

  tearDown(() {
    reset(dateService);
  });

  test(
    'getWeeklyDateRange, '
    'should return WeeklyDateRange object with first and last dates of the week '
    'which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final firstDateOfTheWeek = DateTime(2024, 7, 22);
      final lastDateOfTheWeek = DateTime(2024, 7, 28);
      final WeeklyDateRange expectedWeeklyDateRange = WeeklyDateRange(
        firstDateOfTheWeek: firstDateOfTheWeek,
        lastDateOfTheWeek: lastDateOfTheWeek,
      );
      dateService.mockGetFirstDateOfTheWeek(
        expectedFirstDateOfTheWeek: firstDateOfTheWeek,
      );
      dateService.mockGetLastDateOfTheWeek(
        expectedLastDateOfTheWeek: lastDateOfTheWeek,
      );

      final WeeklyDateRange weeklyDateRange =
          service.getWeeklyDateRange(dateTime);

      expect(weeklyDateRange, expectedWeeklyDateRange);
    },
  );

  test(
    'getMonthlyDateRange, '
    'should return MonthlyDateRange object with first and last dates of the month '
    'which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final firstDateOfTheMonth = DateTime(2024, 7);
      final lastDateOfTheMonth = DateTime(2024, 7, 31);
      final MonthlyDateRange expectedMonthlyDateRange = MonthlyDateRange(
        firstDateOfTheMonth: firstDateOfTheMonth,
        lastDateOfTheMonth: lastDateOfTheMonth,
      );
      dateService.mockGetFirstDateOfTheMonth(
        expectedFirstDateOfTheMonth: firstDateOfTheMonth,
      );
      dateService.mockGetLastDateOfTheMonth(
        expectedLastDateOfTheMonth: lastDateOfTheMonth,
      );

      final MonthlyDateRange monthlyDateRange =
          service.getMonthlyDateRange(dateTime);

      expect(monthlyDateRange, expectedMonthlyDateRange);
    },
  );

  test(
    'getYearlyDateRange, '
    'should return YearlyDateRange object with first and last dates of the year '
    'which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final firstDateOfTheYear = DateTime(2024);
      final lastDateOfTheYear = DateTime(2024, 12, 31);
      final YearlyDateRange expectedYearlyDateRange = YearlyDateRange(
        firstDateOfTheYear: firstDateOfTheYear,
        lastDateOfTheYear: lastDateOfTheYear,
      );
      dateService.mockGetFirstDateOfTheYear(
        expectedFirstDateOfTheYear: firstDateOfTheYear,
      );
      dateService.mockGetLastDateOfTheYear(
        expectedLastDateOfTheYear: lastDateOfTheYear,
      );

      final YearlyDateRange yearlyDateRange =
          service.getYearlyDateRange(dateTime);

      expect(yearlyDateRange, expectedYearlyDateRange);
    },
  );

  group(
    'getPreviousRange, ',
    () {
      test(
        'should return previous week range if range is of type WeeklyDateRange',
        () {
          final WeeklyDateRange currentRange = WeeklyDateRange(
            firstDateOfTheWeek: DateTime(2024, 7, 22),
            lastDateOfTheWeek: DateTime(2024, 7, 28),
          );
          final WeeklyDateRange expectedPreviousRange = WeeklyDateRange(
            firstDateOfTheWeek: DateTime(2024, 7, 15),
            lastDateOfTheWeek: DateTime(2024, 7, 21),
          );

          final DateRange previousRange =
              service.getPreviousRange(currentRange);

          expect(previousRange, expectedPreviousRange);
        },
      );

      test(
        'should return previous month range if range is of type MonthlyDateRange',
        () {
          final MonthlyDateRange currentRange = MonthlyDateRange(
            firstDateOfTheMonth: DateTime(2024, 7),
            lastDateOfTheMonth: DateTime(2024, 7, 31),
          );
          final MonthlyDateRange expectedPreviousRange = MonthlyDateRange(
            firstDateOfTheMonth: DateTime(2024, 6),
            lastDateOfTheMonth: DateTime(2024, 6, 30),
          );

          final DateRange previousRange =
              service.getPreviousRange(currentRange);

          expect(previousRange, expectedPreviousRange);
        },
      );

      test(
        'should return previous year range if range is of type YearlyDateRange',
        () {
          final YearlyDateRange currentRange = YearlyDateRange(
            firstDateOfTheYear: DateTime(2024),
            lastDateOfTheYear: DateTime(2024, 12, 31),
          );
          final YearlyDateRange expectedPreviousRange = YearlyDateRange(
            firstDateOfTheYear: DateTime(2023),
            lastDateOfTheYear: DateTime(2023, 12, 31),
          );

          final DateRange previousRange =
              service.getPreviousRange(currentRange);

          expect(previousRange, expectedPreviousRange);
        },
      );
    },
  );

  group(
    'getNextRange, ',
    () {
      test(
        'should return next week range if range is of type WeeklyDateRange',
        () {
          final WeeklyDateRange currentRange = WeeklyDateRange(
            firstDateOfTheWeek: DateTime(2024, 7, 22),
            lastDateOfTheWeek: DateTime(2024, 7, 28),
          );
          final WeeklyDateRange expectedNextRange = WeeklyDateRange(
            firstDateOfTheWeek: DateTime(2024, 7, 29),
            lastDateOfTheWeek: DateTime(2024, 8, 4),
          );

          final DateRange nextRange = service.getNextRange(currentRange);

          expect(nextRange, expectedNextRange);
        },
      );

      test(
        'should return next month range if range is of type MonthlyDateRange',
        () {
          final MonthlyDateRange currentRange = MonthlyDateRange(
            firstDateOfTheMonth: DateTime(2024, 7),
            lastDateOfTheMonth: DateTime(2024, 7, 31),
          );
          final MonthlyDateRange expectedNextRange = MonthlyDateRange(
            firstDateOfTheMonth: DateTime(2024, 8),
            lastDateOfTheMonth: DateTime(2024, 8, 31),
          );

          final DateRange nextRange = service.getNextRange(currentRange);

          expect(nextRange, expectedNextRange);
        },
      );

      test(
        'should return next year range if range is of type YearlyDateRange',
        () {
          final YearlyDateRange currentRange = YearlyDateRange(
            firstDateOfTheYear: DateTime(2024),
            lastDateOfTheYear: DateTime(2024, 12, 31),
          );
          final YearlyDateRange expectedNextRange = YearlyDateRange(
            firstDateOfTheYear: DateTime(2025),
            lastDateOfTheYear: DateTime(2025, 12, 31),
          );

          final DateRange nextRange = service.getNextRange(currentRange);

          expect(nextRange, expectedNextRange);
        },
      );
    },
  );
}
