import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

import '../../mock/ui_service/mock_number_service.dart';

void main() {
  final numberService = MockNumberService();
  final mapper = DateTimeMapper(numberService);
  final DateTime dateTime = DateTime(2024, 7, 31);
  const String dateTimeStr = '2024-07-31';

  tearDown(() {
    reset(numberService);
  });

  test(
    'mapFromDto, '
    'should map dateTime from String type to DateTime type',
    () {
      final DateTime mappedDateTime = mapper.mapFromDto(dateTimeStr);

      expect(mappedDateTime, dateTime);
    },
  );

  test(
    'mapToDto, '
    'should map dateTime from DateTime type to String type',
    () {
      when(() => numberService.twoDigits(7)).thenReturn('07');
      when(() => numberService.twoDigits(31)).thenReturn('31');

      final String mappedDateTime = mapper.mapToDto(dateTime);

      expect(mappedDateTime, dateTimeStr);
    },
  );
}
