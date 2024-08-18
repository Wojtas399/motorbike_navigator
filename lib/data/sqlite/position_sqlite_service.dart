import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

import 'dto/position_sqlite_dto.dart';
import 'sqlite_db.dart';

@injectable
class PositionSqliteService {
  final SqliteDb _sqliteDb;
  final String _tableName = 'Positions';
  final String _idColName = 'id';
  final String _driveIdColName = 'drive_id';
  final String _orderColName = 'position_order';
  final String _latitudeColName = 'latitude';
  final String _longitudeColName = 'longitude';
  final String _altitudeColName = 'altitude';
  final String _speedColName = 'speed';

  const PositionSqliteService(this._sqliteDb);

  Future<List<PositionSqliteDto>> queryByDriveId({
    required int driveId,
  }) async {
    final db = await _db;
    final List<Map<String, Object?>> positionJsons = await db.query(
      _tableName,
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
    required double altitude,
    required double speedInKmPerH,
  }) async {
    final PositionSqliteDto positionToAdd = PositionSqliteDto(
      driveId: driveId,
      order: order,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      speedInKmPerH: speedInKmPerH,
    );
    final db = await _db;
    final positionId = await db.insert(_tableName, positionToAdd.toJson());
    return await _queryById(id: positionId);
  }

  Future<PositionSqliteDto?> _queryById({
    required int id,
  }) async {
    final db = await _db;
    final List<Map<String, Object?>> positionJsons = await db.query(
      _tableName,
      where: '$_idColName = ?',
      whereArgs: [id],
    );
    return positionJsons.isNotEmpty
        ? PositionSqliteDto.fromJson(positionJsons.first)
        : null;
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
            $_driveIdColName integer not null,
            $_orderColName integer not null,
            $_latitudeColName real not null,
            $_longitudeColName real not null,
            $_altitudeColName real not null,
            $_speedColName real not null,
            FOREIGN KEY($_driveIdColName) REFERENCES Drives(id))
          ''',
    );
  }
}
