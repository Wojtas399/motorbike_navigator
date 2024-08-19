import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/sql_column.dart';
import 'sql_creator.dart';

@singleton
class SqliteDb {
  final String _dbName = 'motorbike_navigator.db';
  final SqlGenerator _sqlGenerator;
  Database? _dbInstance;

  SqliteDb(this._sqlGenerator);

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
    final String sql = _sqlGenerator.generateCreateTableSql(
      tableName: tableName,
      columns: columns,
    );
    await db.execute(sql);
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
        final String enableForeignKeysSql =
            _sqlGenerator.generateEnableForeignKeysSql();
        await db.execute(enableForeignKeysSql);
      },
    );
  }

  Future<String> _loadDbPath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, _dbName);
  }
}
