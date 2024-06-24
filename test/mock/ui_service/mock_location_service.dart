import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/ui/service/location_service.dart';

class MockLocationService extends Mock implements LocationService {
  void mockGetCurrentLocation({Coordinates? expectedLocation}) {
    when(
      getCurrentLocation,
    ).thenAnswer((_) => Stream.value(expectedLocation));
  }
}
