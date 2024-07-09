import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/firebase/firebase_drive_service.dart';

class MockFirebaseDriveService extends Mock implements FirebaseDriveService {
  void mockFetchAllUserDrives({
    required List<DriveDto> expectedDriveDtos,
  }) {
    when(
      () => fetchAllUserDrives(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(expectedDriveDtos));
  }

  void mockAddDrive({
    DriveDto? expectedAddedDriveDto,
  }) {
    when(
      () => addDrive(
        userId: any(named: 'userId'),
        driveDto: any(named: 'driveDto'),
      ),
    ).thenAnswer((_) => Future.value(expectedAddedDriveDto));
  }
}
