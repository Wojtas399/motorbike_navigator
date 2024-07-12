import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository.dart';

class MockDriveRepository extends Mock implements DriveRepository {
  MockDriveRepository() {
    registerFallbackValue(
      const Duration(seconds: 1),
    );
  }

  void mockAddDrive() {
    when(
      () => addDrive(
        userId: any(named: 'userId'),
        startDateTime: any(named: 'startDateTime'),
        distanceInKm: any(named: 'distanceInKm'),
        duration: any(named: 'duration'),
        avgSpeedInKmPerH: any(named: 'avgSpeedInKmPerH'),
        waypoints: any(named: 'waypoints'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
