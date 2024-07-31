import 'package:injectable/injectable.dart';

import '../dto/drive_dto.dart';
import '../dto/position_dto.dart';
import '../mapper/datetime_mapper.dart';
import 'firebase_collections.dart';

@injectable
class FirebaseDriveService {
  final DateTimeMapper _dateTimeMapper;

  const FirebaseDriveService(this._dateTimeMapper);

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
          isGreaterThanOrEqualTo: _dateTimeMapper.mapToDto(firstDateOfRange),
        )
        .where(
          'startDateTime',
          isLessThanOrEqualTo: _dateTimeMapper.mapToDto(lastDateOfRange),
        )
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DriveDto?> addDrive({
    required String userId,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required List<PositionDto> positions,
  }) async {
    final driveToAddDto = DriveDto(
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
      positions: positions,
    );
    final docRef = await getDrivesRef(userId).add(driveToAddDto);
    final snapshot = await docRef.get();
    return snapshot.data();
  }
}
