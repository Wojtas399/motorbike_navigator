import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class MockDriveRepository extends Mock implements DriveRepository {
  MockDriveRepository() {
    registerFallbackValue(
      const Duration(seconds: 1),
    );
  }

  void mockGetDriveById({
    Drive? expectedDrive,
  }) {
    when(
      () => getDriveById(any()),
    ).thenAnswer((_) => Stream.value(expectedDrive));
  }

  void mockGetDrivesFromDateRange({
    required List<Drive> expectedDrives,
  }) {
    when(
      () => getDrivesFromDateRange(
        firstDateOfRange: any(named: 'firstDateOfRange'),
        lastDateOfRange: any(named: 'lastDateOfRange'),
      ),
    ).thenAnswer((_) => Stream.value(expectedDrives));
  }

  void mockAddDrive() {
    when(
      () => addDrive(
        title: any(named: 'title'),
        startDateTime: any(named: 'startDateTime'),
        distanceInKm: any(named: 'distanceInKm'),
        duration: any(named: 'duration'),
        positions: any(named: 'positions'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
