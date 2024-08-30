import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/model/sql_column.dart';
import 'package:motorbike_navigator/data/local_db/service/position_sqlite_service.dart';

import '../../../mock/data/local_db/mock_sqlite_db.dart';

void main() {
  const String tableName = 'Positions';
  const String idColName = 'id';
  const String driveIdColName = 'drive_id';
  const String positionOrderColName = 'position_order';
  const String latitudeColName = 'latitude';
  const String longitudeColName = 'longitude';
  const String altitudeColName = 'altitude';
  const String speedColName = 'speed';
  final sqliteDb = MockSqliteDb();
  final PositionSqliteService service = PositionSqliteService(sqliteDb);

  void verifyTableCreation() {
    verify(
      () => sqliteDb.createTable(
        tableName: tableName,
        columns: const [
          SqlColumn(
            name: idColName,
            type: SqlColumnType.id,
          ),
          SqlColumn(
            name: driveIdColName,
            type: SqlColumnType.integer,
            isNotNull: true,
            foreignKeyReference: 'Drives(id)',
          ),
          SqlColumn(
            name: positionOrderColName,
            type: SqlColumnType.integer,
            isNotNull: true,
          ),
          SqlColumn(
            name: latitudeColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: longitudeColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: altitudeColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: speedColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
        ],
      ),
    ).called(1);
  }

  tearDown(() {
    reset(sqliteDb);
  });

  test(
    'queryByDriveId, '
    'should create table if it does not exist in db, should query drives by id '
    'and should return PositionSqliteDto objects',
    () async {
      const int driveId = 1;
      final List<Map<String, Object?>> driveJsons = [
        {
          idColName: 1,
          driveIdColName: driveId,
          positionOrderColName: 1,
          latitudeColName: 50,
          longitudeColName: 19,
          altitudeColName: 100.1,
          speedColName: 50.5,
        },
        {
          idColName: 2,
          driveIdColName: driveId,
          positionOrderColName: 2,
          latitudeColName: 51,
          longitudeColName: 20,
          altitudeColName: 110.1,
          speedColName: 51.5,
        },
      ];
      final List<PositionSqliteDto> expectedPositionSqliteDtos = [
        const PositionSqliteDto(
          id: 1,
          driveId: driveId,
          order: 1,
          latitude: 50,
          longitude: 19,
          altitude: 100.1,
          speedInKmPerH: 50.5,
        ),
        const PositionSqliteDto(
          id: 2,
          driveId: driveId,
          order: 2,
          latitude: 51,
          longitude: 20,
          altitude: 110.1,
          speedInKmPerH: 51.5,
        ),
      ];
      sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
      sqliteDb.mockCreateTable();
      sqliteDb.mockQuery(expectedResult: driveJsons);

      final List<PositionSqliteDto> positionSqliteDtos =
          await service.queryByDriveId(driveId: driveId);

      expect(positionSqliteDtos, expectedPositionSqliteDtos);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verifyTableCreation();
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$driveIdColName = ?',
          whereArgs: [driveId],
        ),
      ).called(1);
    },
  );

  test(
    'queryByDriveId, '
    'should not create table if it already exists in db, should query drives by '
    'id and should return PositionSqliteDto objects',
    () async {
      const int driveId = 1;
      final List<Map<String, Object?>> driveJsons = [
        {
          idColName: 1,
          driveIdColName: driveId,
          positionOrderColName: 1,
          latitudeColName: 50,
          longitudeColName: 19,
          altitudeColName: 100.1,
          speedColName: 50.5,
        },
        {
          idColName: 2,
          driveIdColName: driveId,
          positionOrderColName: 2,
          latitudeColName: 51,
          longitudeColName: 20,
          altitudeColName: 110.1,
          speedColName: 51.5,
        },
      ];
      final List<PositionSqliteDto> expectedPositionSqliteDtos = [
        const PositionSqliteDto(
          id: 1,
          driveId: driveId,
          order: 1,
          latitude: 50,
          longitude: 19,
          altitude: 100.1,
          speedInKmPerH: 50.5,
        ),
        const PositionSqliteDto(
          id: 2,
          driveId: driveId,
          order: 2,
          latitude: 51,
          longitude: 20,
          altitude: 110.1,
          speedInKmPerH: 51.5,
        ),
      ];
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      sqliteDb.mockQuery(expectedResult: driveJsons);

      final List<PositionSqliteDto> positionSqliteDtos =
          await service.queryByDriveId(driveId: driveId);

      expect(positionSqliteDtos, expectedPositionSqliteDtos);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$driveIdColName = ?',
          whereArgs: [driveId],
        ),
      ).called(1);
    },
  );

  test(
    'insert, '
    'should create table if it does not exist, then should insert passed values '
    'to db and should return PositionSqliteDto object',
    () async {
      const int addedPositionId = 1;
      const int driveId = 1;
      const int order = 1;
      const double latitude = 50.50;
      const double longitude = 19.19;
      const double altitude = 100.10;
      const double speedInKmPerH = 55.55;
      final Map<String, Object?> positionToAddJson = {
        driveIdColName: driveId,
        positionOrderColName: order,
        latitudeColName: latitude,
        longitudeColName: longitude,
        altitudeColName: altitude,
        speedColName: speedInKmPerH,
      };
      final Map<String, Object?> addedPositionJson = {
        idColName: addedPositionId,
        ...positionToAddJson,
      };
      const PositionSqliteDto expectedPositionSqliteDto = PositionSqliteDto(
        id: addedPositionId,
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );
      sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
      sqliteDb.mockCreateTable();
      sqliteDb.mockInsert(expectedId: addedPositionId);
      sqliteDb.mockQuery(expectedResult: [addedPositionJson]);

      final PositionSqliteDto? positionSqliteDto = await service.insert(
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );

      expect(positionSqliteDto, expectedPositionSqliteDto);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verifyTableCreation();
      verify(
        () => sqliteDb.insert(
          tableName: tableName,
          values: positionToAddJson,
        ),
      ).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [addedPositionId],
        ),
      ).called(1);
    },
  );

  test(
    'insert, '
    'should not create table if it already exists, should insert passed values '
    'to db and should return PositionSqliteDto object',
    () async {
      const int addedPositionId = 1;
      const int driveId = 1;
      const int order = 1;
      const double latitude = 50.50;
      const double longitude = 19.19;
      const double altitude = 100.10;
      const double speedInKmPerH = 55.55;
      final Map<String, Object?> positionToAddJson = {
        driveIdColName: driveId,
        positionOrderColName: order,
        latitudeColName: latitude,
        longitudeColName: longitude,
        altitudeColName: altitude,
        speedColName: speedInKmPerH,
      };
      final Map<String, Object?> addedPositionJson = {
        idColName: addedPositionId,
        ...positionToAddJson,
      };
      const PositionSqliteDto expectedPositionSqliteDto = PositionSqliteDto(
        id: addedPositionId,
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      sqliteDb.mockInsert(expectedId: addedPositionId);
      sqliteDb.mockQuery(expectedResult: [addedPositionJson]);

      final PositionSqliteDto? positionSqliteDto = await service.insert(
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        speedInKmPerH: speedInKmPerH,
      );

      expect(positionSqliteDto, expectedPositionSqliteDto);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verify(
        () => sqliteDb.insert(
          tableName: tableName,
          values: positionToAddJson,
        ),
      ).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [addedPositionId],
        ),
      ).called(1);
    },
  );
}
