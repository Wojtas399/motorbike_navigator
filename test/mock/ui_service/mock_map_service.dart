import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/ui/service/map_service.dart';

class MockMapService extends Mock implements MapService {
  MockMapService() {
    registerFallbackValue(const Coordinates(0, 0));
  }

  void mockCalculateDistanceInMeters({
    required double expectedDistance,
  }) {
    when(
      () => calculateDistanceInMeters(
        location1: any(named: 'location1'),
        location2: any(named: 'location2'),
      ),
    ).thenReturn(expectedDistance);
  }
}
