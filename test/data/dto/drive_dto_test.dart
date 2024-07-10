import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';

void main() {
  const String id = 'd1';
  const String userId = 'u1';
  final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
  final DateTime endDateTime = DateTime(2024, 7, 10, 10, 30);
  const double distanceInKm = 10.22;
  const int durationInSeconds = 500000;
  const double avgSpeedInKmPerH = 45.3;
  const List<CoordinatesDto> waypoints = [
    CoordinatesDto(latitude: 50, longitude: 19),
    CoordinatesDto(latitude: 51, longitude: 20),
  ];
  final Map<String, Object?> driveJson = {
    'startDateTime': startDateTime.toIso8601String(),
    'endDateTime': endDateTime.toIso8601String(),
    'distanceInKm': distanceInKm,
    'durationInSeconds': durationInSeconds,
    'avgSpeedInKmPerH': avgSpeedInKmPerH,
    'waypoints': [
      ...waypoints.map((waypoiny) => waypoiny.toJson()),
    ],
  };

  test(
    'fromJson, '
    'should map json object to DriveDto object without changing id and userId',
    () {
      final DriveDto expectedDto = DriveDto(
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );

      final DriveDto dto = DriveDto.fromJson(driveJson);

      expect(dto, expectedDto);
    },
  );

  test(
    'fromFirebaseFirestore, '
    'should map json object to DriveDto object with new id and userId values',
    () {
      final DriveDto expectedDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
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
    'should map DriveDto object to json object without including id and userId',
    () {
      final DriveDto driveDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );

      final Map<String, Object?> json = driveDto.toJson();

      expect(json, driveJson);
    },
  );
}
