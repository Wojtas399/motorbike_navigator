import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/data/sqlite/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/sqlite/dto/position_sqlite_dto.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../../mock/data/mapper/mock_position_mapper.dart';

void main() {
  final positionMapper = MockPositionMapper();

  final DriveMapper mapper = DriveMapper(positionMapper);

  tearDown(() {
    reset(positionMapper);
  });

  test(
    'mapFromDto, '
    'should map DriveSqliteDto model to Drive model (positions should be sorted by '
    'order param and then mapped to Position model)',
    () {
      const int id = 1;
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 10.21;
      const Duration duration = Duration(hours: 1, minutes: 20);
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(51, 19),
          altitude: 1001.22,
          speedInKmPerH: 23.33,
        ),
        Position(
          coordinates: Coordinates(50, 18),
          altitude: 100.22,
          speedInKmPerH: 22.22,
        ),
      ];
      const List<PositionSqliteDto> positionDtos = [
        PositionSqliteDto(
          id: 2,
          driveId: id,
          order: 2,
          latitude: 50,
          longitude: 18,
          altitude: 100.22,
          speedInKmPerH: 22.22,
        ),
        PositionSqliteDto(
          id: 1,
          driveId: id,
          order: 1,
          latitude: 51,
          longitude: 19,
          altitude: 101.22,
          speedInKmPerH: 33.33,
        ),
      ];
      final DriveSqliteDto driveDto = DriveSqliteDto(
        id: id,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );
      final Drive expectedDrive = Drive(
        id: id,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );
      when(
        () => positionMapper.mapFromDto(positionDtos.first),
      ).thenReturn(positions.first);
      when(
        () => positionMapper.mapFromDto(positionDtos.last),
      ).thenReturn(positions.last);

      final Drive drive = mapper.mapFromDto(
        driveDto: driveDto,
        positionDtos: positionDtos,
      );

      expect(drive, expectedDrive);
    },
  );
}
