import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class DriveCreator {
  Drive create({
    String id = '',
    String userId = 'u1',
    DateTime? startDateTime,
    DateTime? endDateTime,
    double distanceInKm = 0,
    int durationInSeconds = 0,
    double avgSpeedInKmPerH = 0,
    List<Coordinates> waypoints = const [],
  }) =>
      Drive(
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
