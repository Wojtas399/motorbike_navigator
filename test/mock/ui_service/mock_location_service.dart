import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/exception/location_exception.dart';
import 'package:motorbike_navigator/ui/service/location_service.dart';

class MockLocationService extends Mock implements LocationService {
  void mockGetLocationStatus({
    required LocationStatus expectedLocationStatus,
  }) {
    when(
      getLocationStatus,
    ).thenAnswer((_) => Stream.value(expectedLocationStatus));
  }

  void mockHasPermission({
    required bool expected,
  }) {
    when(hasPermission).thenAnswer((_) => Future.value(expected));
  }

  void mockGetPosition({
    Position? expectedPosition,
    LocationException? exception,
  }) {
    if (exception != null) {
      when(getPosition).thenThrow(exception);
    } else if (expectedPosition != null) {
      when(getPosition).thenAnswer((_) => Stream.value(expectedPosition));
    }
  }
}
