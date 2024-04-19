import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';
import 'package:motorbike_navigator/data/dto/place_geometry_dto.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';
import 'package:motorbike_navigator/data/mapper/place_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/place.dart';

void main() {
  test(
    'mapPlaceFromDto, '
    'should map PlaceDto object to Place object',
    () {
      const String id = 'p1';
      const String name = 'place';
      const String fullAddress = 'full address';
      const double latitude = 50.5;
      const double longitude = 45.67;
      const PlaceDto dto = PlaceDto(
        properties: PlacePropertiesDto(
          id: id,
          name: name,
          fullAddress: fullAddress,
        ),
        geometry: PlaceGeometryDto(
          coordinates: (lat: latitude, long: longitude),
        ),
      );
      const Place expectedPlace = Place(
        id: id,
        name: name,
        fullAddress: fullAddress,
        coordinates: Coordinates(latitude, longitude),
      );

      final Place place = mapPlaceFromDto(dto);

      expect(place, expectedPlace);
    },
  );
}
