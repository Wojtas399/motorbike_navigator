import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/date_service.dart';

void main() {
  final service = DateService();

  test(
    'getFirstDateOfTheWeek, '
    'should return first date of the week which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateOfTheWeek = DateTime(2024, 7, 22);

      final firstDateOfTheWeek = service.getFirstDateOfTheWeek(dateTime);

      expect(firstDateOfTheWeek, expectedFirstDateOfTheWeek);
    },
  );

  test(
    'getLastDateOfTheWeek, '
    'should return last date of the week which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateOfTheWeek = DateTime(2024, 7, 28);

      final lastDateOfTheWeek = service.getLastDateOfTheWeek(dateTime);

      expect(lastDateOfTheWeek, expectedLastDateOfTheWeek);
    },
  );

  test(
    'getFirstDateOfTheMonth, '
    'should return first dateTime of the month which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateOfTheMonth = DateTime(2024, 7);

      final firstDateOfTheMonth = service.getFirstDateOfTheMonth(dateTime);

      expect(firstDateOfTheMonth, expectedFirstDateOfTheMonth);
    },
  );

  test(
    'getLastDateOfTheMonth, '
    'should return last date of the month which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateOfTheMonth = DateTime(2024, 7, 31);

      final lastDateOfTheMonth = service.getLastDateOfTheMonth(dateTime);

      expect(lastDateOfTheMonth, expectedLastDateOfTheMonth);
    },
  );

  test(
    'getFirstDateOfTheYear, '
    'should return first date of the year which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateOfTheYear = DateTime(2024);

      final firstDateOfTheYear = service.getFirstDateOfTheYear(dateTime);

      expect(firstDateOfTheYear, expectedFirstDateOfTheYear);
    },
  );

  test(
    'getLastDateOfTheYear, '
    'should return last date of the year which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateOfTheYear = DateTime(2024, 12, 31, 23, 59, 59, 999);

      final lastDateOfTheYear = service.getLastDateOfTheYear(dateTime);

      expect(lastDateOfTheYear, expectedLastDateOfTheYear);
    },
  );

  group(
    'getPartOfTheDay, ',
    () {
      test(
        'should return night if hour is 0 ',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 0);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.night;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return night if hour is 5',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 5);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.night;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return night if hour is between 0 and 5',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 3);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.night;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return morning if hour is 6',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 6);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.morning;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return morning if hour is 12',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 12);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.morning;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return morning if hour is between 6 and 12',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 10);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.morning;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return afternoon if hour is 13',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 13);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.afternoon;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return afternoon if hour is 18',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 18);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.afternoon;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return afternoon if hour is between 13 and 18',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 14);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.afternoon;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return evening if hour is 19',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 19);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.evening;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return evening if hour is 23',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 23);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.evening;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );

      test(
        'should return evening if hour is between 19 and 23',
        () {
          final DateTime dateTime = DateTime(2024, 1, 1, 22);
          const PartOfTheDay expectedPartOfTheDay = PartOfTheDay.evening;

          final PartOfTheDay partOfTheDay = service.getPartOfTheDay(dateTime);

          expect(partOfTheDay, expectedPartOfTheDay);
        },
      );
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

          final bool answer = service.isDateFromRange(
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

          final bool answer = service.isDateFromRange(
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

          final bool answer = service.isDateFromRange(
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

          final bool answer = service.isDateFromRange(
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

          final bool answer = service.isDateFromRange(
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

          final bool answer = service.areDatesEqual(date1, date2);

          expect(answer, true);
        },
      );

      test(
        'should return false if years and months are the same but days are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2024, 7, 24, 10, 10);

          final bool answer = service.areDatesEqual(date1, date2);

          expect(answer, false);
        },
      );

      test(
        'should return false if years and days are the same but months are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2024, 8, 25, 10, 10);

          final bool answer = service.areDatesEqual(date1, date2);

          expect(answer, false);
        },
      );

      test(
        'should return false if months and days are the same but years are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25, 12, 30);
          final DateTime date2 = DateTime(2022, 7, 25, 10, 10);

          final bool answer = service.areDatesEqual(date1, date2);

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

          final bool answer = service.areMonthsEqual(date1, date2);

          expect(answer, true);
        },
      );

      test(
        'should return false if years are the same but months are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25);
          final DateTime date2 = DateTime(2024, 6, 25);

          final bool answer = service.areMonthsEqual(date1, date2);

          expect(answer, false);
        },
      );

      test(
        'should return false if months are the same by years are different',
        () {
          final DateTime date1 = DateTime(2024, 7, 25);
          final DateTime date2 = DateTime(2025, 7, 25);

          final bool answer = service.areMonthsEqual(date1, date2);

          expect(answer, false);
        },
      );
    },
  );

  group(
    'calculateNumberOfDaysBetweenDatesInclusively, ',
    () {
      test(
        'should return number of days between two dates from the same month '
        '(given dates also count)',
        () {
          final DateTime from = DateTime(2024, 7, 22);
          final DateTime to = DateTime(2024, 7, 28);
          const int expectedNumberOfDays = 7;

          final int numberOfDays =
              service.calculateNumberOfDaysBetweenDatesInclusively(from, to);

          expect(numberOfDays, expectedNumberOfDays);
        },
      );

      test(
        'should return number of days between two dates from different months '
        '(given dates also count)',
        () {
          final DateTime from = DateTime(2024, 7, 22);
          final DateTime to = DateTime(2024, 8, 4);
          const int expectedNumberOfDays = 14;

          final int numberOfDays =
              service.calculateNumberOfDaysBetweenDatesInclusively(from, to);

          expect(numberOfDays, expectedNumberOfDays);
        },
      );
    },
  );
}
