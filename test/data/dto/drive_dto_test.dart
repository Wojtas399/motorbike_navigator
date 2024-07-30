import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/dto/position_dto.dart';

void main() {
  const String id = 'd1';
  const String userId = 'u1';
  final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
  const double distanceInKm = 10.22;
  const Duration duration = Duration(hours: 1, minutes: 20);
  const double avgSpeedInKmPerH = 45.3;
  const List<PositionDto> positions = [
    PositionDto(
      coordinates: CoordinatesDto(latitude: 50, longitude: 19),
      altitude: 100.22,
      speedInKmPerH: 22.3,
    ),
    PositionDto(
      coordinates: CoordinatesDto(latitude: 51, longitude: 20),
      altitude: 101.22,
      speedInKmPerH: 23.3,
    ),
  ];
  final Map<String, Object?> driveJson = {
    'startDateTime': startDateTime.toIso8601String(),
    'distanceInKm': distanceInKm,
    'duration': duration.inMicroseconds,
    'avgSpeedInKmPerH': avgSpeedInKmPerH,
    'positions': [
      ...positions.map((positions) => positions.toJson()),
    ],
  };

  test(
    'fromJson, '
    'should map json object to DriveDto object without changing id and userId',
    () {
      final DriveDto expectedDto = DriveDto(
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positions,
      );

      final DriveDto dto = DriveDto.fromJson(driveJson);

      expect(dto, expectedDto);
    },
  );

  test(
    'fromFirebaseFirestore, '
    'should map json object to DriveDto object with changed id and userId values',
    () {
      final DriveDto expectedDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positions,
      );

      final DriveDto dto = DriveDto.fromFirebaseFirestore(
        driveId: id,
        userId: userId,
        json: driveJson,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'toJson, '
    'should map DriveDto object to json object without id and userId keys',
    () {
      final DriveDto driveDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positions,
      );

      final Map<String, Object?> json = driveDto.toJson();

      expect(json, driveJson);
    },
  );
}
