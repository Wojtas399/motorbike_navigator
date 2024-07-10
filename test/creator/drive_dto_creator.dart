import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';

class DriveDtoCreator {
  DriveDto create({
    String id = '',
    String userId = '',
    DateTime? startDateTime,
    DateTime? endDateTime,
    double distanceInKm = 0,
    int durationInSeconds = 0,
    double avgSpeedInKmPerH = 0,
    List<CoordinatesDto> waypoints = const [],
  }) =>
      DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime ?? DateTime(2024),
        endDateTime: endDateTime ?? DateTime(2024, 1, 2),
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );
}
