import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository.dart';

class MockDriveRepository extends Mock implements DriveRepository {
  void mockAddDrive() {
    when(
      () => addDrive(
        userId: any(named: 'userId'),
        distanceInKm: any(named: 'distanceInKm'),
        durationInSeconds: any(named: 'durationInSeconds'),
        avgSpeedInKmPerH: any(named: 'avgSpeedInKmPerH'),
        waypoints: any(named: 'waypoints'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
