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
    'toUIDateWithTimeFormat, '
    'should convert DateTime object to string in format dd.mm.yyyy, hh:mm',
    () {
      final DateTime dateTime = DateTime(2024, 10, 5, 14, 25);
      const String expectedStr = '05.10.2024, 14:25';
      when(() => numberService.twoDigits(10)).thenReturn('10');
      when(() => numberService.twoDigits(5)).thenReturn('05');
      when(() => numberService.twoDigits(25)).thenReturn('25');

      final str = dateTime.toUIDateWithTimeFormat();

      expect(str, expectedStr);
      verify(() => numberService.twoDigits(10)).called(1);
      verify(() => numberService.twoDigits(5)).called(1);
      verify(() => numberService.twoDigits(25)).called(1);
    },
  );
}
