import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/service/date_time_service.dart';

class MockDateTimeService extends Mock implements DateTimeService {
  void mockGetNow({
    required DateTime expectedNow,
  }) {
    when(getNow).thenReturn(expectedNow);
  }
}
