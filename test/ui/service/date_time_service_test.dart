import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/date_time_service.dart';

void main() {
  final dateTimeService = DateTimeService();

  test(
    'getFirstDateTimeOfTheWeekWhichIncludesDateTime, '
    'should return first date of the week which include given dateTime',
    () {
      final DateTime dateTime = DateTime(2024, 7, 25, 12, 30);
      final DateTime expectedFirstDateTimeOfTheWeek = DateTime(2024, 7, 22);

      final firstDateTimeOfTheWeek = dateTimeService
          .getFirstDateTimeOfTheWeekWhichIncludesDateTime(dateTime);

      expect(firstDateTimeOfTheWeek, expectedFirstDateTimeOfTheWeek);
    },
  );

  test(
    'getLastDateTimeOfTheWeekWhichIncludedsDateTime, ',
    () {
      final DateTime dateTime = DateTime(2024, 7, 25, 12, 30);
      final DateTime expectedLastDateTimeOfTheWeek =
          DateTime(2024, 7, 28, 23, 59, 59);

      final lastDateTimeOfTheWeek = dateTimeService
          .getLastDateTimeOfTheWeekWhichIncludedsDateTime(dateTime);

      expect(lastDateTimeOfTheWeek, expectedLastDateTimeOfTheWeek);
    },
  );

  group(
    'isDateTimeFromRange, ',
    () {
      final DateTime firstDateTimeOfRange = DateTime(2024, 07, 22, 12, 30);
      final DateTime lastDateTimeOfRange = DateTime(2024, 07, 28, 15, 44);

      test(
        'should return false if date is before first date of range',
        () {
          final DateTime date = DateTime(2024, 07, 22, 12, 15);

          final bool answer = dateTimeService.isDateTimeFromRange(
            date: date,
            firstDateTimeOfRange: firstDateTimeOfRange,
            lastDateTimeOfRange: lastDateTimeOfRange,
          );

          expect(answer, false);
        },
      );

      test(
        'should return false if date is after first date of range',
        () {
          final DateTime date = DateTime(2024, 07, 28, 15, 44, 1);

          final bool answer = dateTimeService.isDateTimeFromRange(
            date: date,
            firstDateTimeOfRange: firstDateTimeOfRange,
            lastDateTimeOfRange: lastDateTimeOfRange,
          );

          expect(answer, false);
        },
      );

      test(
        'should return true if date is equal to first date of range',
        () {
          final DateTime date = firstDateTimeOfRange;

          final bool answer = dateTimeService.isDateTimeFromRange(
            date: date,
            firstDateTimeOfRange: firstDateTimeOfRange,
            lastDateTimeOfRange: lastDateTimeOfRange,
          );

          expect(answer, true);
        },
      );

      test(
        'should return true if date is equal to last date of range',
        () {
          final DateTime date = lastDateTimeOfRange;

          final bool answer = dateTimeService.isDateTimeFromRange(
            date: date,
            firstDateTimeOfRange: firstDateTimeOfRange,
            lastDateTimeOfRange: lastDateTimeOfRange,
          );

          expect(answer, true);
        },
      );

      test(
        'should return true if date is after first date of range and before '
        'last date of range',
        () {
          final DateTime date = DateTime(2024, 07, 22, 12, 30, 1);

          final bool answer = dateTimeService.isDateTimeFromRange(
            date: date,
            firstDateTimeOfRange: firstDateTimeOfRange,
            lastDateTimeOfRange: lastDateTimeOfRange,
          );

          expect(answer, true);
        },
      );
    },
  );
}
