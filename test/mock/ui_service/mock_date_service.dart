import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/service/date_service.dart';

class MockDateService extends Mock implements DateService {
  void mockGetNow({
    required DateTime expectedNow,
  }) {
    when(getNow).thenReturn(expectedNow);
  }
}
