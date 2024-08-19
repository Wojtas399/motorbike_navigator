import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class SqliteDb {
  Database? _dbInstance;

  Future<bool> doesTableNotExist(String tableName) async {
    final database = await _db;
    var result = await database.query(
      'sqlite_master',
      where: 'name = ?',
      whereArgs: [tableName],
    );
    return result.isEmpty;
  }

  Future<void> createTable({
    required String tableName,
    required List<SqlColumn> columns,
  }) async {
    final Database db = await _db;
    String columnsSql = _createColSql(columns.first);
    for (int i = 1; i < columns.length; i++) {
      columnsSql += ', ${_createColSql(columns[i])}';
    }
    await db.execute('create table $tableName ($columnsSql)');
  }

  Future<List<Map<String, Object?>>> query({
    required String tableName,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final Database db = await _db;
    return db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> insert({
    required String tableName,
    required Map<String, Object?> values,
  }) async {
    final Database db = await _db;
    return db.insert(tableName, values);
  }

  Future<Database> get _db async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initializeDb();
    return _dbInstance!;
  }

  Future<Database> _initializeDb() async {
    final String path = await _loadDbPath();
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<String> _loadDbPath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'motorbike_navigator.db');
  }

  String _createColSql(SqlColumn column) {
    String query = '${column.name} ';
    query += switch (column.type) {
      SqlColumnType.integer => 'integer',
      SqlColumnType.real => 'real',
      SqlColumnType.text => 'text',
    };
    if (column.isPrimaryKey) query += ' primary key';
    if (column.isAutoIncrement) query += ' autoincrement';
    if (column.isNotNull) query += ' not null';
    if (column.foreignKeyReferences != null) {
      query +=
          ', FOREIGN KEY(${column.name}) REFERENCES ${column.foreignKeyReferences}';
    }
    return query;
  }
}

enum SqlColumnType { integer, real, text }

class SqlColumn extends Equatable {
  final String name;
  final SqlColumnType type;
  final bool isPrimaryKey;
  final bool isAutoIncrement;
  final bool isNotNull;
  final String? foreignKeyReferences;

  const SqlColumn({
    required this.name,
    required this.type,
    this.isPrimaryKey = false,
    this.isAutoIncrement = false,
    this.isNotNull = false,
    this.foreignKeyReferences,
  });

  @override
  List<Object?> get props => [
        name,
        type,
        isPrimaryKey,
        isNotNull,
        foreignKeyReferences,
      ];
}
