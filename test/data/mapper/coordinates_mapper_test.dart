import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/mapper/coordinates_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';

void main() {
  test(
    'mapCoordinatesFromDto, '
    'should map CoordinatesDto object to Coordinates object',
    () {
      const double latitude = 50.5;
      const double longitude = 45.73;
      const CoordinatesDto dto = CoordinatesDto(latitude, longitude);
      const Coordinates expectedCoordinates = Coordinates(latitude, longitude);

      final Coordinates coordinates = mapCoordinatesFromDto(dto);

      expect(coordinates, expectedCoordinates);
    },
  );
}
