import '../../../entity/coordinates.dart';
import '../../../entity/drive.dart';

abstract interface class DriveRepository {
  Stream<List<Drive>> getAllUserDrives({
    required String userId,
  });

  Stream<List<Drive>> getUserDrivesFromDateRange({
    required String userId,
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  });

  Future<void> addDrive({
    required String userId,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required double avgSpeedInKmPerH,
    required List<Coordinates> waypoints,
  });
}
