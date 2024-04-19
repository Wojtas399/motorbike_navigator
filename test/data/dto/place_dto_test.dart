import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';
import 'package:motorbike_navigator/data/dto/place_geometry_dto.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to PlaceDto object',
    () {
      const String id = 'p1';
      const String name = 'place';
      const String fullAddress = 'full address';
      const double latitude = 50.5;
      const double longitude = 47.6;
      final Map<String, dynamic> json = {
        'properties': {
          'mapbox_id': id,
          'name': name,
          'full_address': fullAddress,
        },
        'geometry': {
          'coordinates': [longitude, latitude],
        },
      };
      const PlaceDto expectedPlaceDto = PlaceDto(
        properties: PlacePropertiesDto(
          id: id,
          name: name,
          fullAddress: fullAddress,
        ),
        geometry: PlaceGeometryDto(
          coordinates: (lat: latitude, long: longitude),
        ),
      );

      final PlaceDto placeDto = PlaceDto.fromJson(json);

      expect(placeDto, expectedPlaceDto);
    },
  );
}
