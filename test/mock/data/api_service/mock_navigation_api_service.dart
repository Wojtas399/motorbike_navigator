import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api_service/navigation_api_service.dart';
import 'package:motorbike_navigator/data/dto/navigation_dto.dart';

class MockNavigationApiService extends Mock implements NavigationApiService {
  MockNavigationApiService() {
    registerFallbackValue((lat: 50.1, long: 18.1));
  }

  void mockFetchNavigation({
    required NavigationDto navigationDto,
  }) {
    when(
      () => fetchNavigation(
        startLocation: any(named: 'startLocation'),
        destinationLocation: any(named: 'destinationLocation'),
      ),
    ).thenAnswer((_) => Future.value(navigationDto));
  }
}
