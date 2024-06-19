import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to RouteGeometryDto object',
    () {
      final Map<String, dynamic> json = {
        'coordinates': [
          [18.1, 50.1],
          [19.2, 51.2],
          [20.3, 52.3],
        ],
      };
      const RouteGeometryDto expectedRouteGeometryDto = RouteGeometryDto(
        coordinates: [
          (lat: 50.1, long: 18.1),
          (lat: 51.2, long: 19.2),
          (lat: 52.3, long: 20.3),
        ],
      );

      final RouteGeometryDto routeGeometryDto = RouteGeometryDto.fromJson(json);

      expect(routeGeometryDto, expectedRouteGeometryDto);
    },
  );
}
