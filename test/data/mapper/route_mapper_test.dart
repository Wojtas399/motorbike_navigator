import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/route_dto.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';
import 'package:motorbike_navigator/data/mapper/route_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/navigation.dart';

void main() {
  test(
    'mapRouteFromDto, '
    'should map RouteDto model to Route model',
    () {
      const double distanceInMeters = 2500.25;
      const RouteDto dto = RouteDto(
        distanceInMeters: distanceInMeters,
        geometry: RouteGeometryDto(
          coordinates: [
            (lat: 18.2, long: 50.2),
            (lat: 19.2, long: 51.2),
          ],
        ),
      );
      const Route expectedRoute = Route(
        distanceInMeters: distanceInMeters,
        waypoints: [
          Coordinates(18.2, 50.2),
          Coordinates(19.2, 51.2),
        ],
      );

      final Route route = mapRouteFromDto(dto);

      expect(route, expectedRoute);
    },
  );
}
