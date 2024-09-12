import '../../../entity/drive.dart';
import '../../../entity/position.dart';

abstract interface class DriveRepository {
  Stream<Drive?> getDriveById(int id);

  Stream<List<Drive>> getAllDrives();

  Stream<List<Drive>> getDrivesFromDateRange({
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  });

  Future<void> addDrive({
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required List<Position> positions,
  });
}
