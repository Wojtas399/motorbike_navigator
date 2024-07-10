import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

void main() {
  const DriveMapper mapper = DriveMapper();

  test(
    'mapFromDto, '
    'should map DriveDto model to Drive model',
    () {
      const String id = 'd1';
      const String userId = 'u1';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 10.21;
      const int durationInSeconds = 50000;
      const double avgSpeedInKmPerH = 15;
      const List<Coordinates> waypoints = [
        Coordinates(50, 18),
        Coordinates(51, 19),
      ];
      const List<CoordinatesDto> waypointsDto = [
        CoordinatesDto(latitude: 50, longitude: 18),
        CoordinatesDto(latitude: 51, longitude: 19),
      ];
      final DriveDto driveDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypointsDto,
      );
      final Drive expectedDrive = Drive(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );

      final Drive drive = mapper.mapFromDto(driveDto);

      expect(drive, expectedDrive);
    },
  );
}
