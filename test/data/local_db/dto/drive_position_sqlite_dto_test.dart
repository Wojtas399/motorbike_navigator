import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_position_sqlite_dto.dart';

void main() {
  const int id = 1;
  const int driveId = 2;
  const int order = 12;
  const double latitude = 50.11;
  const double longitude = 19.19;
  const double elevation = 300.22;
  const double speedInKmPerH = 33.33;

  test(
    'fromJson, '
    'should map json object to DrivePositionSqliteDto object',
    () {
      final Map<String, Object?> json = {
        'id': id,
        'drive_id': driveId,
        'position_order': order,
        'latitude': latitude,
        'longitude': longitude,
        'elevation': elevation,
        'speed': speedInKmPerH,
      };
      const DrivePositionSqliteDto expectedDto = DrivePositionSqliteDto(
        id: id,
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );

      final DrivePositionSqliteDto dto = DrivePositionSqliteDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'toJson, '
    'should map DrivePositionSqliteDto object to json object without id key',
    () {
      const DrivePositionSqliteDto dto = DrivePositionSqliteDto(
        id: id,
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );
      final Map<String, Object?> expectedJson = {
        'drive_id': driveId,
        'position_order': order,
        'latitude': latitude,
        'longitude': longitude,
        'elevation': elevation,
        'speed': speedInKmPerH,
      };

      final Map<String, Object?> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
