import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to PlaceDto object',
    () {
      const String id = 'p1';
      const String name = 'place';
      const double latitude = 50.5;
      const double longitude = 47.6;
      final Map<String, dynamic> json = {
        'properties': {
          'mapbox_id': id,
          'name': name,
        },
        'geometry': {
          'coordinates': [latitude, longitude],
        },
      };
      const PlaceDto expectedPlaceDto = PlaceDto(
        id: id,
        name: name,
        coordinates: CoordinatesDto(latitude, longitude),
      );

      final PlaceDto placeDto = PlaceDto.fromJson(json);

      expect(placeDto, expectedPlaceDto);
    },
  );
}
