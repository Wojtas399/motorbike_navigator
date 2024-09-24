import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/service/position_sqlite_service.dart';

class MockPositionSqliteService extends Mock implements PositionSqliteService {
  void mockQueryByDriveId({
    required List<PositionSqliteDto> expectedPositionSqliteDtos,
  }) {
    when(
      () => queryByDriveId(
        driveId: any(named: 'driveId'),
      ),
    ).thenAnswer((_) => Future.value(expectedPositionSqliteDtos));
  }

  void mockDeleteByDriveId() {
    when(
      () => deleteByDriveId(
        driveId: any(named: 'driveId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
