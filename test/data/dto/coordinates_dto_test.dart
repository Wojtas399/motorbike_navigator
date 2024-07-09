import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';

void main() {
  const double long = 50.2;
  const double lat = 51.2;
  const List<double> coordinatesList = [long, lat];
  const CoordinatesDto coordinatesDto = CoordinatesDto(lat: lat, long: long);

  test(
    'fromJson, '
    'should map list of coordinates to CoordinatesDto object',
    () {
      final CoordinatesDto dto = CoordinatesDto.fromJson(coordinatesList);

      expect(dto, coordinatesDto);
    },
  );

  test(
    'toJson, '
    'should map CoordinatesDto object to list of coordinates',
    () {
      final List<double> list = coordinatesDto.toJson();

      expect(list, coordinatesList);
    },
  );
}
