import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/position_dto.dart';
import 'package:motorbike_navigator/data/mapper/position_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';

void main() {
  const Coordinates coordinates = Coordinates(50, 19);
  const CoordinatesDto coordinatesDto = CoordinatesDto(
    latitude: 50,
    longitude: 19,
  );
  const double altitude = 111.11;
  const double speedInKmPerH = 33.33;
  const mapper = PositionMapper();

  test(
    'fromDto, '
    'should map PositionDto model to Position model',
    () {
      const positionDto = PositionDto(
        coordinates: coordinatesDto,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );
      const expectedPosition = Position(
        coordinates: coordinates,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );

      final position = mapper.mapFromDto(positionDto);

      expect(position, expectedPosition);
    },
  );

  test(
    'toDto, '
    'should map Position model to PositionDto model',
    () {
      const position = Position(
        coordinates: coordinates,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );
      const expectedPositionDto = PositionDto(
        coordinates: coordinatesDto,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );

      final positionDto = mapper.mapToDto(position);

      expect(positionDto, expectedPositionDto);
    },
  );
}
