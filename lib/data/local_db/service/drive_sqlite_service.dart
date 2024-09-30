import 'package:injectable/injectable.dart';

import '../../mapper/datetime_mapper.dart';
import '../dto/drive_sqlite_dto.dart';
import '../model/sql_column.dart';
import '../sqlite_db.dart';

@injectable
class DriveSqliteService {
  final SqliteDb _sqliteDb;
  final DateTimeMapper _dateTimeMapper;
  final String _tableName = 'Drives';
  final String _idColName = 'id';
  final String _titleColName = 'title';
  final String _startDateColName = 'start_date';
  final String _startTimeColName = 'start_time';
  final String _distanceColName = 'distance';
  final String _durationColName = 'duration';

  const DriveSqliteService(this._sqliteDb, this._dateTimeMapper);

  Future<DriveSqliteDto?> queryById({
    required int id,
  }) async {
    await _createTableIfNotExists();
    return await _queryById(id);
  }

  Future<List<DriveSqliteDto>> queryAll() async {
    await _createTableIfNotExists();
    final List<Map<String, Object?>> driveJsons =
        await _sqliteDb.query(tableName: _tableName);
    return driveJsons.map(DriveSqliteDto.fromJson).toList();
  }

  Future<List<DriveSqliteDto>> queryByDateRange({
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) async {
    await _createTableIfNotExists();
    final List<Map<String, Object?>> driveJsons = await _sqliteDb.query(
      tableName: _tableName,
      where: '$_startDateColName >= ? AND $_startDateColName <= ?',
      whereArgs: [
        _dateTimeMapper.mapToDateString(firstDateOfRange),
        _dateTimeMapper.mapToDateString(lastDateOfRange),
      ],
    );
    return driveJsons.map(DriveSqliteDto.fromJson).toList();
  }

  Future<DriveSqliteDto?> insert({
    required String title,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
  }) async {
    await _createTableIfNotExists();
    final driveToAdd = DriveSqliteDto(
      title: title,
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
    );
    final int driveId = await _sqliteDb.insert(
      tableName: _tableName,
      values: driveToAdd.toJson(),
    );
    return await _queryById(driveId);
  }

  Future<DriveSqliteDto?> updateTitle({
    required int driveId,
    required String newTitle,
  }) async {
    if (await _sqliteDb.doesTableNotExist(_tableName)) return null;
    await _sqliteDb.update(
      tableName: _tableName,
      values: {
        _titleColName: newTitle,
      },
      where: '$_idColName = ?',
      whereArgs: [driveId],
    );
    return await _queryById(driveId);
  }

  Future<void> deleteById({
    required int id,
  }) async {
    if (!(await _sqliteDb.doesTableNotExist(_tableName))) {
      await _sqliteDb.delete(
        tableName: _tableName,
        where: '$_idColName = ?',
        whereArgs: [id],
      );
    }
  }

  Future<void> _createTableIfNotExists() async {
    if (await _sqliteDb.doesTableNotExist(_tableName)) {
      await _sqliteDb.createTable(
        tableName: _tableName,
        columns: [
          SqlColumn(
            name: _idColName,
            type: SqlColumnType.id,
          ),
          SqlColumn(
            name: _titleColName,
            type: SqlColumnType.text,
            isNotNull: true,
          ),
          SqlColumn(
            name: _startDateColName,
            type: SqlColumnType.text,
            isNotNull: true,
          ),
          SqlColumn(
            name: _startTimeColName,
            type: SqlColumnType.text,
            isNotNull: true,
          ),
          SqlColumn(
            name: _distanceColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: _durationColName,
            type: SqlColumnType.integer,
            isNotNull: true,
          ),
        ],
      );
    }
  }

  Future<DriveSqliteDto?> _queryById(int id) async {
    final List<Map<String, Object?>> driveJsons = await _sqliteDb.query(
      tableName: _tableName,
      where: '$_idColName = ?',
      whereArgs: [id],
    );
    return driveJsons.isNotEmpty
        ? DriveSqliteDto.fromJson(driveJsons.first)
        : null;
  }
}
