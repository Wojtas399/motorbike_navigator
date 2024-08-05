import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'dto/drive_sqlite_dto.dart';
import 'sqlite_db.dart';

@singleton
class DriveSqliteService {
  final SqliteDb _sqliteDb;
  final String _tableName = 'Drives';
  final String _idColName = 'id';
  final String _startDateTimeColName = 'start_date_time';
  final String _distanceColName = 'distance';
  final String _durationColName = 'duration';
  Database? _dbInstance;

  DriveSqliteService(this._sqliteDb);

  Future<DriveSqliteDto?> insert({
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
  }) async {
    final driveToAdd = DriveSqliteDto(
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
    );
    final db = await _db;
    final int driveId = await db.insert(
      _tableName,
      driveToAdd.toJson(),
    );
    return await getById(id: driveId);
  }

  Future<DriveSqliteDto?> getById({
    required int id,
  }) async {
    final db = await _db;
    final List<Map<String, Object?>> driveJsons = await db.query(
      _tableName,
      where: '$_idColName = ?',
      whereArgs: [id],
    );
    return driveJsons.isNotEmpty
        ? DriveSqliteDto.fromJson(driveJsons.first)
        : null;
  }

  Future<List<DriveSqliteDto>> getAll() async {
    final db = await _db;
    final List<Map<String, Object?>> driveJsons = await db.query(_tableName);
    return driveJsons.map(DriveSqliteDto.fromJson).toList();
  }

  Future<Database> get _db async {
    if (_dbInstance != null) return _dbInstance!;
    _dbInstance = await _initializeDb();
    return _dbInstance!;
  }

  Future<Database> _initializeDb() async {
    final String path = await _sqliteDb.dbPath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $_tableName ( 
            $_idColName integer primary key autoincrement, 
            $_startDateTimeColName text not null,
            $_distanceColName real not null,
            _$_durationColName integer not null)
          ''');
      },
    );
  }
}
