import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_search/models/location.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';

void main() {
  test(
    'fromMapboxLocation, '
    'should map Location object from mapbox_search plugin to CoordinateDto object',
    () {
      const double latitude = 50;
      const double longitude = 50.5;
      const Location location = (lat: latitude, long: longitude);
      const CoordinatesDto expectedDto = CoordinatesDto(latitude, longitude);

      final CoordinatesDto dto = CoordinatesDto.fromMapboxLocation(location);

      expect(dto, expectedDto);
    },
  );
}
