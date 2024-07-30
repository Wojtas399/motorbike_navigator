import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class MockDriveRepository extends Mock implements DriveRepository {
  MockDriveRepository() {
    registerFallbackValue(
      const Duration(seconds: 1),
    );
  }

  void mockGetUserDrivesFromDateRange({
    required List<Drive> expectedDrives,
  }) {
    when(
      () => getUserDrivesFromDateRange(
        userId: any(named: 'userId'),
        firstDateOfRange: any(named: 'firstDateOfRange'),
        lastDateOfRange: any(named: 'lastDateOfRange'),
      ),
    ).thenAnswer((_) => Stream.value(expectedDrives));
  }

  void mockAddDrive() {
    when(
      () => addDrive(
        userId: any(named: 'userId'),
        startDateTime: any(named: 'startDateTime'),
        distanceInKm: any(named: 'distanceInKm'),
        duration: any(named: 'duration'),
        avgSpeedInKmPerH: any(named: 'avgSpeedInKmPerH'),
        positions: any(named: 'positions'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
