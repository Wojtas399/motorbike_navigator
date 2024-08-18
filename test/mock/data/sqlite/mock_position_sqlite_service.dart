import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/sqlite/dto/position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/sqlite/position_sqlite_service.dart';

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
}
