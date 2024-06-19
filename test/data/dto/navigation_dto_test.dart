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
        'uuid': 'n1',
        'routes': [
          {
            'distance': 5.2,
            'geometry': {
              'coordinates': [
                [19.1, 50.1],
                [20.2, 51.2],
              ],
            }
          },
          {
            'distance': 10.5,
            'geometry': {
              'coordinates': [
                [21.3, 51.3],
              ],
            }
          },
        ],
      };
      const NavigationDto expectedNavigationDto = NavigationDto(
        id: 'n1',
        routes: [
          RouteDto(
            distance: 5.2,
            geometry: RouteGeometryDto(
              coordinates: [
                (lat: 50.1, long: 19.1),
                (lat: 51.2, long: 20.2),
              ],
            ),
          ),
          RouteDto(
            distance: 10.5,
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
