import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/sqlite/dto/position_sqlite_dto.dart';

void main() {
  const int id = 1;
  const int driveId = 2;
  const int order = 12;
  const double latitude = 50.11;
  const double longitude = 19.19;
  const double altitude = 300.22;
  const double speedInKmPerH = 33.33;

  test(
    'fromJson, '
    'should map json object to PositionSqliteDto object',
    () {
      final Map<String, Object?> json = {
        'id': id,
        'drive_id': driveId,
        'order': order,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'speed': speedInKmPerH,
      };
      const PositionSqliteDto expectedDto = PositionSqliteDto(
        id: id,
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );

      final PositionSqliteDto dto = PositionSqliteDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'toJson, '
    'should map PositionSqliteDto object to json object without id key',
    () {
      const PositionSqliteDto dto = PositionSqliteDto(
        id: id,
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );
      final Map<String, Object?> expectedJson = {
        'drive_id': driveId,
        'order': order,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'speed': speedInKmPerH,
      };

      final Map<String, Object?> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
