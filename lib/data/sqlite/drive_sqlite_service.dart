import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import '../mapper/datetime_mapper.dart';
import 'dto/drive_sqlite_dto.dart';
import 'sqlite_db.dart';

@injectable
class DriveSqliteService {
  final SqliteDb _sqliteDb;
  final DateTimeMapper _dateTimeMapper;
  final String _tableName = 'Drives';
  final String _idColName = 'id';
  final String _startDateTimeColName = 'start_date_time';
  final String _distanceColName = 'distance';
  final String _durationColName = 'duration';

  const DriveSqliteService(this._sqliteDb, this._dateTimeMapper);

  Future<DriveSqliteDto?> queryById({
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

  Future<List<DriveSqliteDto>> queryAll() async {
    final db = await _db;
    final List<Map<String, Object?>> driveJsons = await db.query(_tableName);
    return driveJsons.map(DriveSqliteDto.fromJson).toList();
  }

  Future<List<DriveSqliteDto>> queryByDateRange({
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) async {
    final db = await _db;
    final List<Map<String, Object?>> driveJsons = await db.query(
      _tableName,
      where: '$_startDateTimeColName >= ? AND $_startDateTimeColName <= ?',
      whereArgs: [
        _dateTimeMapper.mapToDto(firstDateOfRange),
        _dateTimeMapper.mapToDto(lastDateOfRange),
      ],
    );
    return driveJsons.map(DriveSqliteDto.fromJson).toList();
  }

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
    return await queryById(id: driveId);
  }

  Future<Database> get _db async {
    if (await _sqliteDb.doesTableNotExist(_tableName)) {
      await _createTable();
    }
    return _sqliteDb.db;
  }

  Future<void> _createTable() async {
    final db = await _sqliteDb.db;
    await db.execute(
      '''
          create table $_tableName ( 
            $_idColName integer primary key autoincrement, 
            $_startDateTimeColName text not null,
            $_distanceColName real not null,
            $_durationColName integer not null)
          ''',
    );
  }
}
