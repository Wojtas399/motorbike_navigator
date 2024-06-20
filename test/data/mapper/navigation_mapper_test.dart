import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/navigation_dto.dart';
import 'package:motorbike_navigator/data/dto/route_dto.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';
import 'package:motorbike_navigator/data/mapper/navigation_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/navigation.dart';

void main() {
  test(
    'mapNavigationFromDto, '
    'should map NavigationDto model to Navigation model',
    () {
      const Coordinates startLocation = Coordinates(50.1, 18.1);
      const Coordinates endLocation = Coordinates(51.1, 19.1);
      const NavigationDto dto = NavigationDto(
        routes: [
          RouteDto(
            distanceInMeters: 1000.1,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 18.1, long: 50.1),
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
              Coordinates(18.1, 50.1),
            ],
          ),
        ],
      );

      final Navigation navigation = mapNavigationFromDto(
        startLocation: startLocation,
        endLocation: endLocation,
        dto: dto,
      );

      expect(navigation, expectedNavigation);
    },
  );
}
