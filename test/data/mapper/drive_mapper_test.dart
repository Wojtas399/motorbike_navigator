import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

import '../../mock/data/mapper/mock_drive_position_mapper.dart';

void main() {
  final drivePositionMapper = MockDrivePositionMapper();
  final DriveMapper mapper = DriveMapper(drivePositionMapper);

  tearDown(() {
    reset(drivePositionMapper);
  });

  test(
    'mapFromDto, '
    'should map DriveSqliteDto model to Drive model',
    () {
      const int id = 1;
      const String title = 'title';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 10.21;
      const Duration duration = Duration(hours: 1, minutes: 20);
      const List<DrivePosition> positions = [
        DrivePosition(
          order: 2,
          coordinates: Coordinates(50, 18),
          elevation: 100.22,
          speedInKmPerH: 22.22,
        ),
        DrivePosition(
          order: 1,
          coordinates: Coordinates(51, 19),
          elevation: 1001.22,
          speedInKmPerH: 23.33,
        ),
      ];
      const List<DrivePositionSqliteDto> positionDtos = [
        DrivePositionSqliteDto(
          id: 2,
          driveId: id,
          order: 2,
          latitude: 50,
          longitude: 18,
          elevation: 100.22,
          speedInKmPerH: 22.22,
        ),
        DrivePositionSqliteDto(
          id: 1,
          driveId: id,
          order: 1,
          latitude: 51,
          longitude: 19,
          elevation: 101.22,
          speedInKmPerH: 33.33,
        ),
      ];
      final DriveSqliteDto driveDto = DriveSqliteDto(
        id: id,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );
      final Drive expectedDrive = Drive(
        id: id,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );
      when(
        () => drivePositionMapper.mapFromDto(positionDtos.first),
      ).thenReturn(positions.first);
      when(
        () => drivePositionMapper.mapFromDto(positionDtos.last),
      ).thenReturn(positions.last);

      final Drive drive = mapper.mapFromDto(
        driveDto: driveDto,
        positionDtos: positionDtos,
      );

      expect(drive, expectedDrive);
    },
  );
}
