import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/position_dto.dart';

void main() {
  const CoordinatesDto coordinatesDto = CoordinatesDto(
    latitude: 50,
    longitude: 19,
  );
  const double altitude = 100.22;
  const double speedInKmPerH = 22.3;
  const PositionDto positionDto = PositionDto(
    coordinates: coordinatesDto,
    altitude: altitude,
    speedInKmPerH: speedInKmPerH,
  );
  final Map<String, Object?> positionJson = {
    'coordinates': coordinatesDto.toJson(),
    'altitude': altitude,
    'speedInKmPerH': speedInKmPerH,
  };

  test(
    'fromJson, '
    'should map json object to PositionDto',
    () {
      final PositionDto dto = PositionDto.fromJson(positionJson);

      expect(dto, positionDto);
    },
  );

  test(
    'toJson, '
    'should map PositionDto object to json object',
    () {
      final Map<String, Object?> json = positionDto.toJson();

      expect(json, positionJson);
    },
  );
}
