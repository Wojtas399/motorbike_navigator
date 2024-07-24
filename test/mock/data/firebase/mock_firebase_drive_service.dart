import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/firebase/firebase_drive_service.dart';

class MockFirebaseDriveService extends Mock implements FirebaseDriveService {
  MockFirebaseDriveService() {
    registerFallbackValue(
      const Duration(seconds: 1),
    );
  }

  void mockFetchAllUserDrives({
    required List<DriveDto> expectedDriveDtos,
  }) {
    when(
      () => fetchAllUserDrives(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(expectedDriveDtos));
  }

  void mockFetchAllUserDrivesFromDateRange({
    required List<DriveDto> expectedDriveDtos,
  }) {
    when(
      () => fetchAllUserDrivesFromDateRange(
        userId: any(named: 'userId'),
        firstDateTimeOfRange: any(named: 'firstDateTimeOfRange'),
        lastDateTimeOfRange: any(named: 'lastDateTimeOfRange'),
      ),
    ).thenAnswer((_) => Future.value(expectedDriveDtos));
  }

  void mockAddDrive({
    DriveDto? expectedAddedDriveDto,
  }) {
    when(
      () => addDrive(
        userId: any(named: 'userId'),
        startDateTime: any(named: 'startDateTime'),
        distanceInKm: any(named: 'distanceInKm'),
        duration: any(named: 'duration'),
        avgSpeedInKmPerH: any(named: 'avgSpeedInKmPerH'),
        waypoints: any(named: 'waypoints'),
      ),
    ).thenAnswer((_) => Future.value(expectedAddedDriveDto));
  }
}
