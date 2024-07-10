import '../../../entity/coordinates.dart';
import '../../../entity/drive.dart';

abstract interface class DriveRepository {
  Stream<List<Drive>> getAllUserDrives({
    required String userId,
  });

  Future<void> addDrive({
    required String userId,
    required DateTime startDateTime,
    required double distanceInKm,
    required int durationInSeconds,
    required double avgSpeedInKmPerH,
    required List<Coordinates> waypoints,
  });
}
