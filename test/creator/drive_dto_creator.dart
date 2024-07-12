import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';

class DriveDtoCreator {
  DriveDto create({
    String id = '',
    String userId = '',
    DateTime? startDateTime,
    double distanceInKm = 0,
    Duration duration = const Duration(seconds: 0),
    double avgSpeedInKmPerH = 0,
    List<CoordinatesDto> waypoints = const [],
  }) =>
      DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime ?? DateTime(2024),
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );
}
