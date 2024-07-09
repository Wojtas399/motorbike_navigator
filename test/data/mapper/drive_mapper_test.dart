import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

void main() {
  final DriveMapper mapper = DriveMapper();

  test(
    'mapFromDto, '
    'should map DriveDto model to Drive model',
    () {
      const String id = 'd1';
      const String userId = 'u1';
      const double distanceInKm = 10.21;
      const int durationInSeconds = 50000;
      const double avgSpeedInKmPerH = 15;
      const List<Coordinates> waypoints = [
        Coordinates(50, 18),
        Coordinates(51, 19),
      ];
      const List<CoordinatesDto> waypointsDto = [
        CoordinatesDto(lat: 50, long: 18),
        CoordinatesDto(lat: 51, long: 19),
      ];
      const DriveDto driveDto = DriveDto(
        id: id,
        userId: userId,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypointsDto,
      );
      const Drive expectedDrive = Drive(
        id: id,
        userId: userId,
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
