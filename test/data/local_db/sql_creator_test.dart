import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/local_db/model/sql_column.dart';
import 'package:motorbike_navigator/data/local_db/sql_creator.dart';

void main() {
  const generator = SqlGenerator();
  const String tableName = 'Entities';

  test(
    'generateCreateTableSql, '
    'column is of type id, '
    'should add "integer primary key autoincrement" values to column params',
    () {
      const String columnName = 'id';
      const SqlColumn column = SqlColumn(
        name: columnName,
        type: SqlColumnType.id,
      );
      const String expectedSql =
          'CREATE TABLE $tableName ($columnName INTEGER PRIMARY KEY AUTOINCREMENT)';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: [column],
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateCreateTableSql, '
    'column is of type integer, '
    'should add "integer" value to column params',
    () {
      const String columnName = 'id';
      const SqlColumn column = SqlColumn(
        name: columnName,
        type: SqlColumnType.integer,
      );
      const String expectedSql =
          'CREATE TABLE $tableName ($columnName INTEGER)';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: [column],
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateCreateTableSql, '
    'column is of type real, '
    'should add "real" value to column params',
    () {
      const String columnName = 'id';
      const SqlColumn column = SqlColumn(
        name: columnName,
        type: SqlColumnType.real,
      );
      const String expectedSql = 'CREATE TABLE $tableName ($columnName REAL)';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: [column],
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateCreateTableSql, '
    'column is of type text, '
    'should add "text" value to column params',
    () {
      const String columnName = 'id';
      const SqlColumn column = SqlColumn(
        name: columnName,
        type: SqlColumnType.text,
      );
      const String expectedSql = 'CREATE TABLE $tableName ($columnName TEXT)';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: [column],
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateCreateTableSql, '
    'column has isNotNull param set as true, '
    'should add "not null" value to column params',
    () {
      const String columnName = 'id';
      const SqlColumn column = SqlColumn(
        name: columnName,
        type: SqlColumnType.integer,
        isNotNull: true,
      );
      const String expectedSql =
          'CREATE TABLE $tableName ($columnName INTEGER NOT NULL)';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: [column],
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateCreateTableSql, '
    'column is a foreign key, '
    'should add foreign key reference',
    () {
      const String columnName = 'id';
      const String foreignKeyReference = 'Cars(id)';
      const SqlColumn column = SqlColumn(
        name: columnName,
        type: SqlColumnType.integer,
        foreignKeyReference: foreignKeyReference,
      );
      const String expectedSql =
          'CREATE TABLE $tableName ($columnName INTEGER, FOREIGN KEY($columnName) REFERENCES $foreignKeyReference)';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: [column],
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateCreateTableSql, '
    'should list all columns with their params separated by comma and should '
    'add foreign key references at the end of the list',
    () {
      const List<SqlColumn> columns = [
        SqlColumn(
          name: 'id',
          type: SqlColumnType.id,
        ),
        SqlColumn(
          name: 'family_id',
          type: SqlColumnType.integer,
          isNotNull: true,
          foreignKeyReference: 'Families(id)',
        ),
        SqlColumn(
          name: 'name',
          type: SqlColumnType.text,
          isNotNull: true,
        ),
        SqlColumn(
          name: 'surname',
          type: SqlColumnType.text,
        ),
        SqlColumn(
          name: 'age',
          type: SqlColumnType.integer,
          isNotNull: true,
        ),
      ];
      const String expectedSql =
          'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, family_id INTEGER NOT NULL, name TEXT NOT NULL, surname TEXT, age INTEGER NOT NULL, FOREIGN KEY(family_id) REFERENCES Families(id))';

      final String sql = generator.generateCreateTableSql(
        tableName: tableName,
        columns: columns,
      );

      expect(sql, expectedSql);
    },
  );

  test(
    'generateEnableForeignKeysSql, '
    'should return PRAGMA command with foreign_keys param set as ON',
    () {
      const String expectedSql = 'PRAGMA foreign_keys = ON';

      final String sql = generator.generateEnableForeignKeysSql();

      expect(sql, expectedSql);
    },
  );
}
