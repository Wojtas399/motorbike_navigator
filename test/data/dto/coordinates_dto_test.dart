import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';

void main() {
  const double latitude = 51.2;
  const double longitude = 50.2;
  const Map<String, Object?> coordinatesJson = {
    'latitude': latitude,
    'longitude': longitude,
  };
  const CoordinatesDto coordinatesDto = CoordinatesDto(
    latitude: latitude,
    longitude: longitude,
  );

  test(
    'fromJson, '
    'should map json object to CoordinatesDto object',
    () {
      final CoordinatesDto dto = CoordinatesDto.fromJson(coordinatesJson);

      expect(dto, coordinatesDto);
    },
  );

  test(
    'toJson, '
    'should map CoordinatesDto object to json object',
    () {
      final Map<String, Object?> json = coordinatesDto.toJson();

      expect(json, coordinatesJson);
    },
  );
}
