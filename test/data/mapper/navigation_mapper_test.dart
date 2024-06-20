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
      const String id = 'n1';
      const NavigationDto dto = NavigationDto(
        id: id,
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
      const Navigation expectedNavigation = Navigation(
        id: id,
        routes: [
          Route(
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(18.1, 50.1),
            ],
          ),
        ],
      );

      final Navigation navigation = mapNavigationFromDto(dto);

      expect(navigation, expectedNavigation);
    },
  );
}
