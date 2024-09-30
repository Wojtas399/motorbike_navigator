import 'package:injectable/injectable.dart';

import 'model/sql_column.dart';

@injectable
class SqlGenerator {
  const SqlGenerator();

  String generateCreateTableSql({
    required String tableName,
    required List<SqlColumn> columns,
  }) {
    String columnsSql = _createColSql(columns.first);
    for (int i = 1; i < columns.length; i++) {
      columnsSql += ', ${_createColSql(columns[i])}';
    }
    final foreignKeys = columns.where(
      (col) => col.foreignKeyReference != null,
    );
    for (final foreignKeyCol in foreignKeys) {
      columnsSql += ', ${_createForeignKeyReference(foreignKeyCol)}';
    }
    return 'CREATE TABLE $tableName ($columnsSql)';
  }

  String generateEnableForeignKeysSql() => 'PRAGMA foreign_keys = ON';

  String _createColSql(SqlColumn column) {
    String query = '${column.name} ';
    if (column.type == SqlColumnType.id) {
      return query += 'INTEGER PRIMARY KEY AUTOINCREMENT';
    }
    query += switch (column.type) {
      SqlColumnType.integer => 'INTEGER',
      SqlColumnType.real => 'REAL',
      SqlColumnType.text => 'TEXT',
      SqlColumnType.id => '',
    };
    if (column.isNotNull) query += ' NOT NULL';
    return query;
  }

  String _createForeignKeyReference(SqlColumn column) =>
      'FOREIGN KEY(${column.name}) REFERENCES ${column.foreignKeyReference}';
}
