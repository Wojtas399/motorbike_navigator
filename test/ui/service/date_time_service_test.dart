import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/date_time_service.dart';

void main() {
  final dateTimeService = DateTimeService();

  test(
    'getFirstDateTimeOfTheWeek, '
    'should return first dateTime of the week which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateTimeOfTheWeek = DateTime(2024, 7, 22);

      final firstDateTimeOfTheWeek =
          dateTimeService.getFirstDateTimeOfTheWeek(dateTime);

      expect(firstDateTimeOfTheWeek, expectedFirstDateTimeOfTheWeek);
    },
  );

  test(
    'getLastDateTimeOfTheWeek, '
    'should return last dateTime of the week which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateTimeOfTheWeek =
          DateTime(2024, 7, 28, 23, 59, 59, 999);

      final lastDateTimeOfTheWeek =
          dateTimeService.getLastDateTimeOfTheWeek(dateTime);

      expect(lastDateTimeOfTheWeek, expectedLastDateTimeOfTheWeek);
    },
  );

  test(
    'getFirstDateTimeOfTheMonth, '
    'should return first dateTime of the month which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedFirstDateTimeOfTheMonth = DateTime(2024, 7);

      final firstDateTimeOfTheMonth =
          dateTimeService.getFirstDateTimeOfTheMonth(dateTime);

      expect(firstDateTimeOfTheMonth, expectedFirstDateTimeOfTheMonth);
    },
  );

  test(
    'getLastDateTimeOfTheMonth, '
    'should return last dateTime of the month which includes given dateTime',
    () {
      final dateTime = DateTime(2024, 7, 25, 12, 30);
      final expectedLastDateTimeOfTheMonth =
          DateTime(2024, 7, 31, 23, 59, 59, 999);

      final lastDateTimeOfTheMonth =
          dateTimeService.getLastDateTimeOfTheMonth(dateTime);

      expect(lastDateTimeOfTheMonth, expectedLastDateTimeOfTheMonth);
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
