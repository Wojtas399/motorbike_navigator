import 'package:injectable/injectable.dart';

import '../dto/coordinates_dto.dart';
import '../dto/drive_dto.dart';
import 'firebase_collections.dart';

@injectable
class FirebaseDriveService {
  Future<List<DriveDto>> fetchAllUserDrives({
    required String userId,
  }) async {
    final snapshot = await getDrivesRef(userId).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<DriveDto>> fetchAllUserDrivesFromDateRange({
    required String userId,
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) async {
    final snapshot = await getDrivesRef(userId)
        .where(
          'startDateTime',
          isGreaterThanOrEqualTo: firstDateOfRange.toIso8601String(),
        )
        .where(
          'startDateTime',
          isLessThanOrEqualTo: lastDateOfRange.toIso8601String(),
        )
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DriveDto?> addDrive({
    required String userId,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required double avgSpeedInKmPerH,
    required List<CoordinatesDto> waypoints,
  }) async {
    final driveToAddDto = DriveDto(
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
      avgSpeedInKmPerH: avgSpeedInKmPerH,
      waypoints: waypoints,
    );
    final docRef = await getDrivesRef(userId).add(driveToAddDto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
