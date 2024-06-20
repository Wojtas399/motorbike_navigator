import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api_service/navigation_api_service.dart';
import 'package:motorbike_navigator/data/dto/navigation_dto.dart';
import 'package:motorbike_navigator/data/dto/route_dto.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';

import '../../mock/data/api/mock_mapbox_navigation_api.dart';

void main() {
  final mapboxNavigationApi = MockMapboxNavigationApi();
  late NavigationApiService apiService;

  setUp(() {
    apiService = NavigationApiService(mapboxNavigationApi);
  });

  test(
    'fetchNavigation, '
    'should fetch navigation json from MapboxNavigationApi and should map it '
    'to NavigationDto object',
    () async {
      const startLocation = (lat: 50.1, long: 18.1);
      const destinationLocation = (lat: 51.2, long: 19.2);
      final Map<String, dynamic> json = {
        'routes': [
          {
            'distance': 1000.1,
            'geometry': {
              'coordinates': [
                [18.1, 50.1],
                [19.2, 51.2],
              ],
            },
          },
          {
            'distance': 1500.2,
            'geometry': {
              'coordinates': [
                [17.12, 49.12],
              ],
            },
          }
        ],
      };
      const NavigationDto expectedNavigationDto = NavigationDto(
        routes: [
          RouteDto(
            distanceInMeters: 1000.1,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 50.1, long: 18.1),
                (lat: 51.2, long: 19.2),
              ],
            ),
          ),
          RouteDto(
            distanceInMeters: 1500.2,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 49.12, long: 17.12),
              ],
            ),
          ),
        ],
      );
      mapboxNavigationApi.mockFetchNavigation(result: json);

      final NavigationDto navigationDto = await apiService.fetchNavigation(
        startLocation: startLocation,
        destinationLocation: destinationLocation,
      );

      expect(navigationDto, expectedNavigationDto);
      verify(
        () => mapboxNavigationApi.fetchNavigation(
          startLocation: startLocation,
          destinationLocation: destinationLocation,
        ),
      ).called(1);
    },
  );
}
