import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_position_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

void main() {
  const int order = 1;
  const double latitude = 50.50;
  const double longitude = 19.19;
  const Coordinates coordinates = Coordinates(latitude, longitude);
  const double elevation = 111.11;
  const double speedInKmPerH = 33.33;
  const mapper = DrivePositionMapper();

  test(
    'mapFromDto, '
    'should map DrivePositionSqliteDto model to DrivePosition model',
    () {
      const positionDto = DrivePositionSqliteDto(
        id: 1,
        driveId: 1,
        order: order,
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );
      const expectedPosition = DrivePosition(
        order: order,
        coordinates: coordinates,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );

      final position = mapper.mapFromDto(positionDto);

      expect(position, expectedPosition);
    },
  );
}
