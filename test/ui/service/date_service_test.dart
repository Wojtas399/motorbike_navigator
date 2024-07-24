import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/date_service.dart';

void main() {
  final dateService = DateService();

  group(
    'isDateFromRange, ',
    () {
      final DateTime firstDateOfRange = DateTime(2024, 07, 22, 12, 30);
      final DateTime lastDateOfRange = DateTime(2024, 07, 28, 15, 44);

      test(
        'should return false if date is before first date of range',
        () {
          final DateTime date = DateTime(2024, 07, 22, 12, 15);

          final bool answer = dateService.isDateFromRange(
            date: date,
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(answer, false);
        },
      );

      test(
        'should return false if date is after first date of range',
        () {
          final DateTime date = DateTime(2024, 07, 28, 15, 44, 1);

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
          final DateTime date = firstDateOfRange;

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
          final DateTime date = lastDateOfRange;

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
          final DateTime date = DateTime(2024, 07, 22, 12, 30, 1);

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
}
