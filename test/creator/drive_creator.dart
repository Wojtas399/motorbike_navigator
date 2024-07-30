import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

class DriveCreator {
  Drive create({
    String id = '',
    String userId = 'u1',
    DateTime? startDateTime,
    double distanceInKm = 0,
    Duration duration = const Duration(seconds: 0),
    double avgSpeedInKmPerH = 0,
    List<Position> positions = const [],
  }) =>
      Drive(
        id: id,
        userId: userId,
        startDateTime: startDateTime ?? DateTime(2024),
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positions,
      );
}
