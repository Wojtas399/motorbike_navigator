import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/date_service.dart';

void main() {
  final dateService = DateService();

  test(
    'getFirstDateOfTheWeek, '
    'should return first date of the week which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateOfTheWeek = DateTime(2024, 7, 22);

      final firstDateOfTheWeek = dateService.getFirstDateOfTheWeek(dateTime);

      expect(firstDateOfTheWeek, expectedFirstDateOfTheWeek);
    },
  );

  test(
    'getLastDateOfTheWeek, '
    'should return last date of the week which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateOfTheWeek = DateTime(2024, 7, 28);

      final lastDateOfTheWeek = dateService.getLastDateOfTheWeek(dateTime);

      expect(lastDateOfTheWeek, expectedLastDateOfTheWeek);
    },
  );

  test(
    'getFirstDateOfTheMonth, '
    'should return first dateTime of the month which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateOfTheMonth = DateTime(2024, 7);

      final firstDateOfTheMonth = dateService.getFirstDateOfTheMonth(dateTime);

      expect(firstDateOfTheMonth, expectedFirstDateOfTheMonth);
    },
  );

  test(
    'getLastDateOfTheMonth, '
    'should return last date of the month which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateOfTheMonth = DateTime(2024, 7, 31);

      final lastDateOfTheMonth = dateService.getLastDateOfTheMonth(dateTime);

      expect(lastDateOfTheMonth, expectedLastDateOfTheMonth);
    },
  );

  test(
    'getFirstDateOfTheYear, '
    'should return first date of the year which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateOfTheYear = DateTime(2024);

      final firstDateOfTheYear = dateService.getFirstDateOfTheYear(dateTime);

      expect(firstDateOfTheYear, expectedFirstDateOfTheYear);
    },
  );

  test(
    'getLastDateOfTheYear, '
    'should return last date of the year which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateOfTheYear = DateTime(2024, 12, 31, 23, 59, 59, 999);

      final lastDateOfTheYear = dateService.getLastDateOfTheYear(dateTime);

      expect(lastDateOfTheYear, expectedLastDateOfTheYear);
    },
  );

  group(
    'isDateFromRange, ',
    () {
      final DateTime firstDateOfRange = DateTime(2024, 07, 22, 12, 30);
      final DateTime lastDateOfRange = DateTime(2024, 07, 28, 15, 44);

      test(
        'should return false if date is before first date of range',
        () {
          final DateTime date = DateTime(2024, 07, 21, 12, 15);

          final bool answer = dateService.isDateFromRange(
            date: date,
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(answer, false);
        },
      );

      test(
        'should return false if date is after last date of range',
        () {
          final DateTime date = DateTime(2024, 07, 29, 15, 44, 1);

          final bool answer = dateService.isDateFromRange(
            date: date,
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(answer, false);
        },
      );

      test(
        'should return true if date is equal to first date of range',
        () {
          final DateTime date = DateTime(2024, 07, 22, 10, 30);

          final bool answer = dateService.isDateFromRange(
            date: date,
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(answer, true);
        },
      );

      test(
        'should return true if date is equal to last date of range',
        () {
          final DateTime date = DateTime(2024, 07, 28, 15, 45);

          final bool answer = dateService.isDateFromRange(
            date: date,
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(answer, true);
        },
      );

      test(
        'should return true if date is after first date of range and before '
        'last date of range',
        () {
          final DateTime date = DateTime(2024, 07, 23, 12, 30, 1);

          final bool answer = dateService.isDateFromRange(
            date: date,
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(answer, true);
        },
      );
    },
  );

  group(
    'areDatesEqual, ',
    () {
      test(
        'should return true if years, months and days are the same',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2024, 7, 25, 10, 10);

          final bool answer = dateService.areDatesEqual(date1, date2);

          expect(answer, true);
        },
      );

      test(
        'should return false if years and months are the same but days are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2024, 7, 24, 10, 10);

          final bool answer = dateService.areDatesEqual(date1, date2);

          expect(answer, false);
        },
      );

      test(
        'should return false if years and days are the same but months are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2024, 8, 25, 10, 10);

          final bool answer = dateService.areDatesEqual(date1, date2);

          expect(answer, false);
        },
      );

      test(
        'should return false if months and days are the same but years are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2022, 7, 25, 10, 10);

          final bool answer = dateService.areDatesEqual(date1, date2);

          expect(answer, false);
        },
      );
    },
  );

  group(
    'areMonthsEqual, ',
    () {
      test(
        'should return true if years and months are the same',
        () {
          final DateTime date1 = DateTime(2024, 7, 25);
          final DateTime date2 = DateTime(2024, 7, 24);

          final bool answer = dateService.areMonthsEqual(date1, date2);

          expect(answer, true);
        },
      );

      test(
        'should return false if years are the same but months are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25);
          final DateTime date2 = DateTime(2024, 6, 25);

          final bool answer = dateService.areMonthsEqual(date1, date2);

          expect(answer, false);
        },
      );

      test(
        'should return false if months are the same by years are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25);
          final DateTime date2 = DateTime(2025, 7, 25);

          final bool answer = dateService.areMonthsEqual(date1, date2);

          expect(answer, false);
        },
      );
    },
  );
}
