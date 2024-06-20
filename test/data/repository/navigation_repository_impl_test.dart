import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/navigation_dto.dart';
import 'package:motorbike_navigator/data/dto/route_dto.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';
import 'package:motorbike_navigator/data/repository/navigation/navigation_repository_impl.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/navigation.dart';

import '../../mock/data/api_service/mock_navigation_api_service.dart';

void main() {
  final navigationApiService = MockNavigationApiService();
  late NavigationRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = NavigationRepositoryImpl(navigationApiService);
  });

  test(
    'loadNavigationByStartAndEndLocations, '
    'should load navigation from db, add it to repo state and return it id '
    'navigation does not exist in repo state, '
    'should only return navigation if it already exists in repo state',
    () async {
      const Coordinates startLocation = Coordinates(50.1, 18.1);
      const Coordinates endLocation = Coordinates(50.2, 18.2);
      const NavigationDto navigationDto = NavigationDto(
        routes: [
          RouteDto(
            distanceInMeters: 1000.1,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 50.1, long: 18.1),
              ],
            ),
          ),
          RouteDto(
            distanceInMeters: 2000.2,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 51.2, long: 19.2),
              ],
            ),
          ),
        ],
      );
      final Navigation expectedNavigation = Navigation(
        startLocation: startLocation,
        endLocation: endLocation,
        routes: const [
          Route(
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(50.1, 18.1),
            ],
          ),
          Route(
            distanceInMeters: 2000.2,
            waypoints: [
              Coordinates(51.2, 19.2),
            ],
          ),
        ],
      );
      navigationApiService.mockFetchNavigation(navigationDto: navigationDto);

      final Navigation? navigation1 =
          await repositoryImpl.loadNavigationByStartAndEndLocations(
        startLocation: startLocation,
        endLocation: endLocation,
      );
      final Navigation? navigation2 =
          await repositoryImpl.loadNavigationByStartAndEndLocations(
        startLocation: startLocation,
        endLocation: endLocation,
      );

      expect(navigation1, expectedNavigation);
      expect(navigation2, expectedNavigation);
      verify(
        () => navigationApiService.fetchNavigation(
          startLocation: (
            lat: startLocation.latitude,
            long: startLocation.longitude,
          ),
          destinationLocation: (
            lat: endLocation.latitude,
            long: endLocation.longitude,
          ),
        ),
      ).called(1);
    },
  );
}
