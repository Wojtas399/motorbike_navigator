import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class DriveCreator {
  Drive create({
    String id = '',
    String userId = 'u1',
    double distanceInKm = 0,
    int durationInSeconds = 0,
    double avgSpeedInKmPerH = 0,
    List<Coordinates> waypoints = const [],
  }) =>
      Drive(
        id: id,
        userId: userId,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );
}
