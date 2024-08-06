import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

@singleton
class SqliteDb {
  Database? _dbInstance;

  Future<Database> get db async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initializeDb();
    return _dbInstance!;
  }

  Future<bool> doesTableNotExist(String tableName) async {
    final database = await db;
    var result = await database.query(
      'sqlite_master',
      where: 'name = ?',
      whereArgs: [tableName],
    );
    return result.isEmpty;
  }

  Future<Database> _initializeDb() async {
    final String path = await _loadDbPath();
    return await openDatabase(path, version: 1);
  }

  Future<String> _loadDbPath() async {
    var databasesPath = await getDatabasesPath();
    return join(databasesPath, 'motorbike_navigator.db');
  }
}
