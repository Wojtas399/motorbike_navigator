import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api/mapbox_navigation_api.dart';

class MockMapboxNavigationApi extends Mock implements MapboxNavigationApi {
  MockMapboxNavigationApi() {
    registerFallbackValue((lat: 50.1, long: 18.1));
  }

  void mockFetchNavigation({
    required Map<String, dynamic> result,
  }) {
    when(
      () => fetchNavigation(
        startLocation: any(named: 'startLocation'),
        destinationLocation: any(named: 'destinationLocation'),
      ),
    ).thenAnswer((_) => Future.value(result));
  }
}
