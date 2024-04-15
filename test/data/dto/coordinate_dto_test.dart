import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_search/models/location.dart';
import 'package:motorbike_navigator/data/dto/coordinate_dto.dart';

void main() {
  test(
    'fromMapboxLocation, '
    'should map Location object from mapbox_search plugin to CoordinateDto object',
    () {
      const double latitude = 50;
      const double longitude = 50.5;
      const Location location = (lat: latitude, long: longitude);
      const CoordinateDto expectedDto = CoordinateDto(latitude, longitude);

      final CoordinateDto dto = CoordinateDto.fromMapboxLocation(location);

      expect(dto, expectedDto);
    },
  );
}
