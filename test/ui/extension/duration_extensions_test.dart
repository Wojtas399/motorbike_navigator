import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/extensions/duration_extensions.dart';

void main() {
  test(
    'toUIFormat, '
    'should map Duration object to string in format Hh Mmin Ss',
    () {
      const Duration duration = Duration(hours: 1, minutes: 5, seconds: 31);
      const String expectedDurationStr = '1h 5min 31s';

      final String durationStr = duration.toUIFormat();

      expect(durationStr, expectedDurationStr);
    },
  );
}
