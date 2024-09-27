import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

void main() {
  const DriveMapper mapper = DriveMapper();

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

      final Drive drive = mapper.mapFromDto(
        driveDto: driveDto,
        positions: positions,
      );

      expect(drive, expectedDrive);
    },
  );
}
