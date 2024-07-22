import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/service/location_service.dart';

class MockLocationService extends Mock implements LocationService {
  void mockGetPosition({Position? expectedPosition}) {
    when(getPosition).thenAnswer((_) => Stream.value(expectedPosition));
  }

  void mockLoadLocation({Coordinates? expectedLocation}) {
    when(loadLocation).thenAnswer((_) => Future.value(expectedLocation));
  }
}
