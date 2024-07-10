import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/service/number_service.dart';

class MockNumberService extends Mock implements NumberService {
  void mockTwoDigits({
    required String expected,
  }) {
    when(
      () => twoDigits(any()),
    ).thenReturn(expected);
  }
}
