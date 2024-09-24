import 'package:injectable/injectable.dart';

import '../dto/position_sqlite_dto.dart';
import '../model/sql_column.dart';
import '../sqlite_db.dart';

@injectable
class PositionSqliteService {
  final SqliteDb _sqliteDb;
  final String _tableName = 'Positions';
  final String _idColName = 'id';
  final String _driveIdColName = 'drive_id';
  final String _orderColName = 'position_order';
  final String _latitudeColName = 'latitude';
  final String _longitudeColName = 'longitude';
  final String _elevationColName = 'elevation';
  final String _speedColName = 'speed';

  const PositionSqliteService(this._sqliteDb);

  Future<List<PositionSqliteDto>> queryByDriveId({
    required int driveId,
  }) async {
    await _createTableIfNotExists();
    final List<Map<String, Object?>> positionJsons = await _sqliteDb.query(
      tableName: _tableName,
      where: '$_driveIdColName = ?',
      whereArgs: [driveId],
    );
    return positionJsons.map(PositionSqliteDto.fromJson).toList();
  }

  Future<PositionSqliteDto?> insert({
    required int driveId,
    required int order,
    required double latitude,
    required double longitude,
    required double elevation,
    required double speedInKmPerH,
  }) async {
    await _createTableIfNotExists();
    final PositionSqliteDto positionToAdd = PositionSqliteDto(
      driveId: driveId,
      order: order,
      latitude: latitude,
      longitude: longitude,
      elevation: elevation,
      speedInKmPerH: speedInKmPerH,
    );
    final positionId = await _sqliteDb.insert(
      tableName: _tableName,
      values: positionToAdd.toJson(),
    );
    return await _queryById(id: positionId);
  }

  Future<void> deleteByDriveId({
    required int driveId,
  }) async {
    if (!(await _sqliteDb.doesTableNotExist(_tableName))) {
      await _sqliteDb.delete(
        tableName: _tableName,
        where: '$_driveIdColName = ?',
        whereArgs: [driveId],
      );
    }
  }

  Future<PositionSqliteDto?> _queryById({
    required int id,
  }) async {
    final List<Map<String, Object?>> positionJsons = await _sqliteDb.query(
      tableName: _tableName,
      where: '$_idColName = ?',
      whereArgs: [id],
    );
    return positionJsons.isNotEmpty
        ? PositionSqliteDto.fromJson(positionJsons.first)
        : null;
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
            name: _driveIdColName,
            type: SqlColumnType.integer,
            isNotNull: true,
            foreignKeyReference: 'Drives(id)',
          ),
          SqlColumn(
            name: _orderColName,
            type: SqlColumnType.integer,
            isNotNull: true,
          ),
          SqlColumn(
            name: _latitudeColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: _longitudeColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: _elevationColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: _speedColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
        ],
      );
    }
  }
}
