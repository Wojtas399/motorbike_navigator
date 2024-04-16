import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_geometry_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to PlaceGeometryDto object',
    () {
      const double latitude = 50.5;
      const double longitude = 47.6;
      final Map<String, dynamic> json = {
        'coordinates': [latitude, longitude],
      };
      const PlaceGeometryDto expectedPlaceGeometryDto = PlaceGeometryDto(
        coordinates: (lat: latitude, long: longitude),
      );

      final PlaceGeometryDto placeGeometryDto = PlaceGeometryDto.fromJson(json);

      expect(placeGeometryDto, expectedPlaceGeometryDto);
    },
  );
}
