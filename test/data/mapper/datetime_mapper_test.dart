import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

import '../../mock/ui_service/mock_number_service.dart';

void main() {
  final numberService = MockNumberService();
  final mapper = DateTimeMapper(numberService);
  final DateTime dateTime = DateTime(2024, 7, 31, 2, 30);
  const String dateStr = '2024-07-31';
  const String timeStr = '02:30';

  tearDown(() {
    reset(numberService);
  });

  test(
    'mapFromDateAndTimeStrings, '
    'should map date and time from Strings to DateTime type',
    () {
      final DateTime mappedDateTime =
          mapper.mapFromDateAndTimeStrings(dateStr, timeStr);

      expect(mappedDateTime, dateTime);
    },
  );

  test(
    'mapToDateString, '
    'should map date from DateTime type to String type',
    () {
      when(() => numberService.twoDigits(7)).thenReturn('07');
      when(() => numberService.twoDigits(31)).thenReturn('31');

      final String mappedDate = mapper.mapToDateString(dateTime);

      expect(mappedDate, dateStr);
    },
  );

  test(
    'mapToTimeString, '
    'should map time from DateTime type to String type',
    () {
      when(() => numberService.twoDigits(2)).thenReturn('02');
      when(() => numberService.twoDigits(30)).thenReturn('30');

      final String mappedTime = mapper.mapToTimeString(dateTime);

      expect(mappedTime, timeStr);
    },
  );
}
