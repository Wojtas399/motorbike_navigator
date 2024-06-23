import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/route_dto.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to RouteDto object',
    () {
      const double durationInSeconds = 333.333;
      const double distanceInMeters = 3450.20;
      final Map<String, dynamic> json = {
        'duration': durationInSeconds,
        'distance': distanceInMeters,
        'geometry': {
          'coordinates': [
            [18.1, 50.1],
            [19.2, 51.2],
            [20.3, 52.3],
          ],
        },
      };
      const RouteDto expectedRouteDto = RouteDto(
        durationInSeconds: durationInSeconds,
        distanceInMeters: distanceInMeters,
        geometry: RouteGeometryDto(
          coordinates: [
            (lat: 50.1, long: 18.1),
            (lat: 51.2, long: 19.2),
            (lat: 52.3, long: 20.3),
          ],
        ),
      );

      final RouteDto routeDto = RouteDto.fromJson(json);

      expect(routeDto, expectedRouteDto);
    },
  );
}
