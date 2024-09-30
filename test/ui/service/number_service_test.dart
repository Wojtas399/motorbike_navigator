import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/number_service.dart';

void main() {
  final service = NumberService();

  test(
    'twoDigits, '
    'number contains only one digit, '
    'should return given number concatenated with 0 before it',
    () {
      const int number = 8;
      const String expectedNumberStr = '0$number';

      final String numberStr = service.twoDigits(number);

      expect(numberStr, expectedNumberStr);
    },
  );

  test(
    'twoDigits, '
    'number contains two digits, '
    'should return given number converted to string',
    () {
      const int number = 21;
      const String expectedNumberStr = '$number';

      final String numberStr = service.twoDigits(number);

      expect(numberStr, expectedNumberStr);
    },
  );

  test(
    'twoDigits, '
    'number contains more than two digits, '
    'should return given number converted to string',
    () {
      const int number = 2122;
      const String expectedNumberStr = '$number';

      final String numberStr = service.twoDigits(number);

      expect(numberStr, expectedNumberStr);
    },
  );
}
