import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/sqlite_db.dart';

class MockSqliteDb extends Mock implements SqliteDb {
  void mockDoesTableNotExist({
    required bool expectedAnswer,
  }) {
    when(
      () => doesTableNotExist(any()),
    ).thenAnswer((_) => Future.value(expectedAnswer));
  }

  void mockCreateTable() {
    when(
      () => createTable(
        tableName: any(named: 'tableName'),
        columns: any(named: 'columns'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockQuery({
    required List<Map<String, Object?>> expectedResult,
  }) {
    when(
      () => query(
        tableName: any(named: 'tableName'),
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((_) => Future.value(expectedResult));
  }

  void mockInsert({
    required int expectedId,
  }) {
    when(
      () => insert(
        tableName: any(named: 'tableName'),
        values: any(named: 'values'),
      ),
    ).thenAnswer((_) => Future.value(expectedId));
  }

  void mockDelete() {
    when(
      () => delete(
        tableName: any(named: 'tableName'),
        where: any(named: 'where'),
        whereArgs: any(named: 'whereArgs'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
