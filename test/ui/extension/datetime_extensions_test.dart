import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/dependency_injection.dart';
import 'package:motorbike_navigator/ui/extensions/datetime_extensions.dart';
import 'package:motorbike_navigator/ui/service/number_service.dart';

import '../../mock/ui_service/mock_number_service.dart';

void main() {
  final numberService = MockNumberService();

  setUpAll(() {
    getIt.registerFactory<NumberService>(() => numberService);
  });

  test(
    'toUIDate, '
    'should convert DateTime object to string in format dd.mm.yyyy',
    () {
      final DateTime dateTime = DateTime(2024, 10, 5, 14, 25);
      const String expectedStr = '05.10.2024';
      when(() => numberService.twoDigits(10)).thenReturn('10');
      when(() => numberService.twoDigits(5)).thenReturn('05');

      final str = dateTime.toUIDate();

      expect(str, expectedStr);
      verify(() => numberService.twoDigits(10)).called(1);
      verify(() => numberService.twoDigits(5)).called(1);
    },
  );

  test(
    'toUITime, '
    'should convert DateTime object to string in format h:mm',
    () {
      final DateTime dateTime = DateTime(2024, 10, 5, 9, 5);
      const String expectedStr = '9:05';
      when(() => numberService.twoDigits(5)).thenReturn('05');

      final str = dateTime.toUITime();

      expect(str, expectedStr);
      verify(() => numberService.twoDigits(5)).called(1);
    },
  );
}
