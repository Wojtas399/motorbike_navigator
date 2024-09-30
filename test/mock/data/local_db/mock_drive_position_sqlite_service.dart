import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/service/drive_position_sqlite_service.dart';

class MockDrivePositionSqliteService extends Mock
    implements DrivePositionSqliteService {
  void mockQueryByDriveId({
    required List<DrivePositionSqliteDto> expectedDrivePositionSqliteDtos,
  }) {
    when(
      () => queryByDriveId(
        driveId: any(named: 'driveId'),
      ),
    ).thenAnswer((_) => Future.value(expectedDrivePositionSqliteDtos));
  }

  void mockDeleteByDriveId() {
    when(
      () => deleteByDriveId(
        driveId: any(named: 'driveId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
