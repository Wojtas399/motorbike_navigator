import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';
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
      const CoordinatesDto coordinatesDto = CoordinatesDto(50.5, 45.67);
      const Coordinates coordinates = Coordinates(50.5, 45.67);
      const PlaceDto dto = PlaceDto(
        id: id,
        name: name,
        coordinates: coordinatesDto,
      );
      const Place expectedPlace = Place(
        id: id,
        name: name,
        coordinates: coordinates,
      );

      final Place place = mapPlaceFromDto(dto);

      expect(place, expectedPlace);
    },
  );
}
