import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

class DriveCreator {
  Drive create({
    int id = 0,
    DateTime? startDateTime,
    double distanceInKm = 0,
    Duration duration = const Duration(seconds: 0),
    List<Position> positions = const [],
  }) =>
      Drive(
        id: id,
        startDateTime: startDateTime ?? DateTime(2024),
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );
}
