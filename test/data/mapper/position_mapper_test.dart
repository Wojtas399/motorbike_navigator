import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/mapper/position_mapper.dart';
import 'package:motorbike_navigator/data/sqlite/dto/position_sqlite_dto.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';

void main() {
  const double latitude = 50.50;
  const double longitude = 19.19;
  const Coordinates coordinates = Coordinates(latitude, longitude);
  const double altitude = 111.11;
  const double speedInKmPerH = 33.33;
  const mapper = PositionMapper();

  test(
    'mapFromDto, '
    'should map PositionSqliteDto model to Position model',
    () {
      const positionDto = PositionSqliteDto(
        id: 1,
        driveId: 1,
        order: 1,
        latitude: latitude,
        longitude: longitude,
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
}
