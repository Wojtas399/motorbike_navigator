import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to CoordinateDto object',
    () {
      const double latitude = 50;
      const double longitude = 50.5;
      final Map<String, dynamic> json = {
        'coordinates': [latitude, longitude],
      };
      const CoordinatesDto expectedDto = CoordinatesDto(latitude, longitude);

      final CoordinatesDto dto = CoordinatesDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );
}
