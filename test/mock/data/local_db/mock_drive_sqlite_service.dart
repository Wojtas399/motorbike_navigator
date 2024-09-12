import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/service/drive_sqlite_service.dart';

class MockDriveSqliteService extends Mock implements DriveSqliteService {
  MockDriveSqliteService() {
    registerFallbackValue(const Duration(seconds: 1));
  }

  void mockQueryById({
    DriveSqliteDto? expectedDriveSqliteDto,
  }) {
    when(
      () => queryById(
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) => Future.value(expectedDriveSqliteDto));
  }

  void mockQueryAll({
    required List<DriveSqliteDto> expectedDriveSqliteDtos,
  }) {
    when(queryAll).thenAnswer((_) => Future.value(expectedDriveSqliteDtos));
  }

  void mockQueryByDateRange({
    required List<DriveSqliteDto> expectedDriveSqliteDtos,
  }) {
    when(
      () => queryByDateRange(
        firstDateOfRange: any(named: 'firstDateOfRange'),
        lastDateOfRange: any(named: 'lastDateOfRange'),
      ),
    ).thenAnswer((_) => Future.value(expectedDriveSqliteDtos));
  }

  void mockInsert({
    DriveSqliteDto? expectedInsertedDriveSqliteDto,
  }) {
    when(
      () => insert(
        startDateTime: any(named: 'startDateTime'),
        distanceInKm: any(named: 'distanceInKm'),
        duration: any(named: 'duration'),
      ),
    ).thenAnswer((_) => Future.value(expectedInsertedDriveSqliteDto));
  }
}
