import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/navigation_dto.dart';
import 'package:motorbike_navigator/data/dto/route_dto.dart';
import 'package:motorbike_navigator/data/dto/route_geometry_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to NavigationDto object',
    () {
      final Map<String, dynamic> json = {
        'routes': [
          {
            'distance': 500.2,
            'geometry': {
              'coordinates': [
                [19.1, 50.1],
                [20.2, 51.2],
              ],
            }
          },
          {
            'distance': 1000.5,
            'geometry': {
              'coordinates': [
                [21.3, 51.3],
              ],
            }
          },
        ],
      };
      const NavigationDto expectedNavigationDto = NavigationDto(
        routes: [
          RouteDto(
            distanceInMeters: 500.2,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 50.1, long: 19.1),
                (lat: 51.2, long: 20.2),
              ],
            ),
          ),
          RouteDto(
            distanceInMeters: 1000.5,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 51.3, long: 21.3),
              ],
            ),
          ),
        ],
      );

      final NavigationDto navigationDto = NavigationDto.fromJson(json);

      expect(navigationDto, expectedNavigationDto);
    },
  );
}
