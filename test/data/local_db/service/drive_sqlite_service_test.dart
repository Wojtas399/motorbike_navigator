import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/model/sql_column.dart';
import 'package:motorbike_navigator/data/local_db/service/drive_sqlite_service.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

import '../../../mock/data/local_db/mock_sqlite_db.dart';
import '../../../mock/data/mapper/mock_datetime_mapper.dart';

void main() {
  const String tableName = 'Drives';
  const String idColName = 'id';
  const String startDateColName = 'start_date';
  const String startTimeColName = 'start_time';
  const String distanceColName = 'distance';
  const String durationColName = 'duration';
  final sqliteDb = MockSqliteDb();
  final dateTimeMapper = MockDatetimeMapper();
  final service = DriveSqliteService(sqliteDb, dateTimeMapper);

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
            name: startDateColName,
            type: SqlColumnType.text,
            isNotNull: true,
          ),
          SqlColumn(
            name: startTimeColName,
            type: SqlColumnType.text,
            isNotNull: true,
          ),
          SqlColumn(
            name: distanceColName,
            type: SqlColumnType.real,
            isNotNull: true,
          ),
          SqlColumn(
            name: durationColName,
            type: SqlColumnType.integer,
            isNotNull: true,
          ),
        ],
      ),
    ).called(1);
  }

  setUpAll(() {
    GetIt.I.registerFactory<DateTimeMapper>(() => dateTimeMapper);
  });

  tearDown(() {
    reset(sqliteDb);
    reset(dateTimeMapper);
  });

  test(
    'queryById, '
    'should create table if it does not exist in db and should return '
    'DriveSqliteDto object if drive with passed id exists in table',
    () async {
      const int driveId = 1;
      final DateTime startDateTime = DateTime(2024, 8, 20, 12, 30);
      const double distance = 22.22;
      const Duration duration = Duration(minutes: 33, seconds: 20);
      final Map<String, Object?> driveJson = {
        idColName: driveId,
        startDateColName: '2024-08-20',
        startTimeColName: '12:30',
        distanceColName: distance,
        durationColName: duration.inSeconds,
      };
      final DriveSqliteDto expectedDriveSqliteDto = DriveSqliteDto(
        id: driveId,
        startDateTime: startDateTime,
        distanceInKm: distance,
        duration: duration,
      );
      sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
      sqliteDb.mockCreateTable();
      sqliteDb.mockQuery(expectedResult: [driveJson]);
      dateTimeMapper.mockMapFromDateAndTimeStrings(
        expectedDateTime: startDateTime,
      );

      final DriveSqliteDto? driveSqliteDto =
          await service.queryById(id: driveId);

      expect(driveSqliteDto, expectedDriveSqliteDto);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verifyTableCreation();
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [driveId],
        ),
      ).called(1);
    },
  );

  test(
    'queryById, '
    'should not create table if it already exists in db and should return '
    'DriveSqliteDto object if drive with passed id exists in table',
    () async {
      const int driveId = 1;
      final DateTime startDateTime = DateTime(2024, 8, 20, 12, 30);
      const double distance = 22.22;
      const Duration duration = Duration(minutes: 33, seconds: 20);
      final Map<String, Object?> driveJson = {
        idColName: driveId,
        startDateColName: '2024-08-20',
        startTimeColName: '12:30',
        distanceColName: distance,
        durationColName: duration.inSeconds,
      };
      final DriveSqliteDto expectedDriveSqliteDto = DriveSqliteDto(
        id: driveId,
        startDateTime: startDateTime,
        distanceInKm: distance,
        duration: duration,
      );
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      sqliteDb.mockQuery(expectedResult: [driveJson]);
      dateTimeMapper.mockMapFromDateAndTimeStrings(
        expectedDateTime: startDateTime,
      );

      final DriveSqliteDto? driveSqliteDto =
          await service.queryById(id: driveId);

      expect(driveSqliteDto, expectedDriveSqliteDto);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [driveId],
        ),
      ).called(1);
    },
  );

  test(
    'queryById, '
    'should return null if drive with passed id does not exist in table',
    () async {
      const int driveId = 1;
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      sqliteDb.mockQuery(expectedResult: []);

      final DriveSqliteDto? driveSqliteDto =
          await service.queryById(id: driveId);

      expect(driveSqliteDto, null);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [driveId],
        ),
      ).called(1);
    },
  );

  test(
    'queryAll, '
    'should create table if it does not exist in db, should query all drives '
    'from table and should return them',
    () async {
      final List<Map<String, Object?>> allDriveJsons = [
        {
          idColName: 1,
          startDateColName: '2024-08-20',
          startTimeColName: '02:30',
          distanceColName: 22.22,
          durationColName: const Duration(minutes: 33, seconds: 20).inSeconds,
        },
        {
          idColName: 2,
          startDateColName: '2024-08-21',
          startTimeColName: '12:31',
          distanceColName: 44.44,
          durationColName: const Duration(minutes: 44, seconds: 24).inSeconds,
        },
        {
          idColName: 3,
          startDateColName: '2024-08-22',
          startTimeColName: '21:10',
          distanceColName: 10.10,
          durationColName: const Duration(minutes: 11, seconds: 11).inSeconds,
        },
      ];
      final List<DriveSqliteDto> expectedAllDriveSqliteDtos = [
        DriveSqliteDto(
          id: 1,
          startDateTime: DateTime(2024, 8, 20, 2, 30),
          distanceInKm: 22.22,
          duration: const Duration(minutes: 33, seconds: 20),
        ),
        DriveSqliteDto(
          id: 2,
          startDateTime: DateTime(2024, 8, 21, 12, 31),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 24),
        ),
        DriveSqliteDto(
          id: 3,
          startDateTime: DateTime(2024, 8, 22, 21, 10),
          distanceInKm: 10.10,
          duration: const Duration(minutes: 11, seconds: 11),
        ),
      ];
      sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
      sqliteDb.mockCreateTable();
      sqliteDb.mockQuery(expectedResult: allDriveJsons);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          allDriveJsons.first[startDateColName] as String,
          allDriveJsons.first[startTimeColName] as String,
        ),
      ).thenReturn(expectedAllDriveSqliteDtos.first.startDateTime);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          allDriveJsons[1][startDateColName] as String,
          allDriveJsons[1][startTimeColName] as String,
        ),
      ).thenReturn(expectedAllDriveSqliteDtos[1].startDateTime);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          allDriveJsons.last[startDateColName] as String,
          allDriveJsons.last[startTimeColName] as String,
        ),
      ).thenReturn(expectedAllDriveSqliteDtos.last.startDateTime);

      final List<DriveSqliteDto> allDriveSqliteDtos = await service.queryAll();

      expect(allDriveSqliteDtos, expectedAllDriveSqliteDtos);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verifyTableCreation();
      verify(
        () => sqliteDb.query(tableName: tableName),
      ).called(1);
    },
  );

  test(
    'queryAll, '
    'should not create table if it already exists in db, should query all drives '
    'from table and should return them',
    () async {
      final List<Map<String, Object?>> allDriveJsons = [
        {
          idColName: 1,
          startDateColName: '2024-08-20',
          startTimeColName: '02:30',
          distanceColName: 22.22,
          durationColName: const Duration(minutes: 33, seconds: 20).inSeconds,
        },
        {
          idColName: 2,
          startDateColName: '2024-08-21',
          startTimeColName: '12:31',
          distanceColName: 44.44,
          durationColName: const Duration(minutes: 44, seconds: 24).inSeconds,
        },
        {
          idColName: 3,
          startDateColName: '2024-08-22',
          startTimeColName: '21:10',
          distanceColName: 10.10,
          durationColName: const Duration(minutes: 11, seconds: 11).inSeconds,
        },
      ];
      final List<DriveSqliteDto> expectedAllDriveSqliteDtos = [
        DriveSqliteDto(
          id: 1,
          startDateTime: DateTime(2024, 8, 20, 2, 30),
          distanceInKm: 22.22,
          duration: const Duration(minutes: 33, seconds: 20),
        ),
        DriveSqliteDto(
          id: 2,
          startDateTime: DateTime(2024, 8, 21, 12, 31),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 24),
        ),
        DriveSqliteDto(
          id: 3,
          startDateTime: DateTime(2024, 8, 22, 21, 10),
          distanceInKm: 10.10,
          duration: const Duration(minutes: 11, seconds: 11),
        ),
      ];
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      sqliteDb.mockQuery(expectedResult: allDriveJsons);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          allDriveJsons.first[startDateColName] as String,
          allDriveJsons.first[startTimeColName] as String,
        ),
      ).thenReturn(expectedAllDriveSqliteDtos.first.startDateTime);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          allDriveJsons[1][startDateColName] as String,
          allDriveJsons[1][startTimeColName] as String,
        ),
      ).thenReturn(expectedAllDriveSqliteDtos[1].startDateTime);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          allDriveJsons.last[startDateColName] as String,
          allDriveJsons.last[startTimeColName] as String,
        ),
      ).thenReturn(expectedAllDriveSqliteDtos.last.startDateTime);

      final List<DriveSqliteDto> allDriveSqliteDtos = await service.queryAll();

      expect(allDriveSqliteDtos, expectedAllDriveSqliteDtos);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verify(
        () => sqliteDb.query(tableName: tableName),
      ).called(1);
    },
  );

  test(
    'queryByDateRange, '
    'should create table if it does not exist in db, should query drives which '
    'started between passed date range and should return them',
    () async {
      final DateTime firstDateOfRange = DateTime(2024, 8, 20);
      final DateTime lastDateOfRange = DateTime(2024, 8, 21);
      const String firstDateOfRangeStr = '2024-08-20';
      const String lastDateOfRangeStr = '2024-08-21';
      final List<Map<String, Object?>> driveJsons = [
        {
          idColName: 1,
          startDateColName: '2024-08-20',
          startTimeColName: '02:30',
          distanceColName: 22.22,
          durationColName: const Duration(minutes: 33, seconds: 20).inSeconds,
        },
        {
          idColName: 2,
          startDateColName: '2024-08-21',
          startTimeColName: '12:31',
          distanceColName: 44.44,
          durationColName: const Duration(minutes: 44, seconds: 24).inSeconds,
        },
      ];
      final List<DriveSqliteDto> expectedDriveSqliteDtos = [
        DriveSqliteDto(
          id: 1,
          startDateTime: DateTime(2024, 8, 20, 2, 30),
          distanceInKm: 22.22,
          duration: const Duration(minutes: 33, seconds: 20),
        ),
        DriveSqliteDto(
          id: 2,
          startDateTime: DateTime(2024, 8, 21, 12, 31),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 24),
        ),
      ];
      sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
      sqliteDb.mockCreateTable();
      when(
        () => dateTimeMapper.mapToDateString(firstDateOfRange),
      ).thenReturn(firstDateOfRangeStr);
      when(
        () => dateTimeMapper.mapToDateString(lastDateOfRange),
      ).thenReturn(lastDateOfRangeStr);
      sqliteDb.mockQuery(expectedResult: driveJsons);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          driveJsons.first[startDateColName] as String,
          driveJsons.first[startTimeColName] as String,
        ),
      ).thenReturn(expectedDriveSqliteDtos.first.startDateTime);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          driveJsons.last[startDateColName] as String,
          driveJsons.last[startTimeColName] as String,
        ),
      ).thenReturn(expectedDriveSqliteDtos.last.startDateTime);

      final List<DriveSqliteDto> driveSqliteDtos =
          await service.queryByDateRange(
        firstDateOfRange: firstDateOfRange,
        lastDateOfRange: lastDateOfRange,
      );

      expect(driveSqliteDtos, expectedDriveSqliteDtos);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verifyTableCreation();
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$startDateColName >= ? AND $startDateColName <= ?',
          whereArgs: [
            firstDateOfRangeStr,
            lastDateOfRangeStr,
          ],
        ),
      ).called(1);
    },
  );

  test(
    'queryByDateRange, '
    'should not create table if it already exists in db, should query drives '
    'which started between passed date range and should return them',
    () async {
      final DateTime firstDateOfRange = DateTime(2024, 8, 20);
      final DateTime lastDateOfRange = DateTime(2024, 8, 21);
      const String firstDateOfRangeStr = '2024-08-20';
      const String lastDateOfRangeStr = '2024-08-21';
      final List<Map<String, Object?>> driveJsons = [
        {
          idColName: 1,
          startDateColName: '2024-08-20',
          startTimeColName: '02:30',
          distanceColName: 22.22,
          durationColName: const Duration(minutes: 33, seconds: 20).inSeconds,
        },
        {
          idColName: 2,
          startDateColName: '2024-08-21',
          startTimeColName: '12:31',
          distanceColName: 44.44,
          durationColName: const Duration(minutes: 44, seconds: 24).inSeconds,
        },
      ];
      final List<DriveSqliteDto> expectedDriveSqliteDtos = [
        DriveSqliteDto(
          id: 1,
          startDateTime: DateTime(2024, 8, 20, 2, 30),
          distanceInKm: 22.22,
          duration: const Duration(minutes: 33, seconds: 20),
        ),
        DriveSqliteDto(
          id: 2,
          startDateTime: DateTime(2024, 8, 21, 12, 31),
          distanceInKm: 44.44,
          duration: const Duration(minutes: 44, seconds: 24),
        ),
      ];
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      when(
        () => dateTimeMapper.mapToDateString(firstDateOfRange),
      ).thenReturn(firstDateOfRangeStr);
      when(
        () => dateTimeMapper.mapToDateString(lastDateOfRange),
      ).thenReturn(lastDateOfRangeStr);
      sqliteDb.mockQuery(expectedResult: driveJsons);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          driveJsons.first[startDateColName] as String,
          driveJsons.first[startTimeColName] as String,
        ),
      ).thenReturn(expectedDriveSqliteDtos.first.startDateTime);
      when(
        () => dateTimeMapper.mapFromDateAndTimeStrings(
          driveJsons.last[startDateColName] as String,
          driveJsons.last[startTimeColName] as String,
        ),
      ).thenReturn(expectedDriveSqliteDtos.last.startDateTime);

      final List<DriveSqliteDto> driveSqliteDtos =
          await service.queryByDateRange(
        firstDateOfRange: firstDateOfRange,
        lastDateOfRange: lastDateOfRange,
      );

      expect(driveSqliteDtos, expectedDriveSqliteDtos);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$startDateColName >= ? AND $startDateColName <= ?',
          whereArgs: [
            firstDateOfRangeStr,
            lastDateOfRangeStr,
          ],
        ),
      ).called(1);
    },
  );

  test(
    'insert, '
    'should create table if it does not exist in db, should insert passed values '
    'to table and should return DriveSqliteDto object',
    () async {
      const int addedDriveId = 1;
      final DateTime startDateTime = DateTime(2024, 8, 20, 2, 30);
      const String startDateStr = '2024-08-20';
      const String startTimeStr = '02:30';
      const double distanceInKm = 22.22;
      const Duration duration = Duration(minutes: 25, seconds: 30);
      final Map<String, Object> driveToAddJson = {
        startDateColName: startDateStr,
        startTimeColName: startTimeStr,
        distanceColName: distanceInKm,
        durationColName: duration.inSeconds,
      };
      final Map<String, Object> addedDriveJson = {
        idColName: addedDriveId,
        ...driveToAddJson,
      };
      final DriveSqliteDto expectedDriveSqliteDto = DriveSqliteDto(
        id: addedDriveId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );
      sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
      sqliteDb.mockCreateTable();
      dateTimeMapper.mockMapToDateString(expectedDateStr: startDateStr);
      dateTimeMapper.mockMapToTimeString(expectedTimeStr: startTimeStr);
      sqliteDb.mockInsert(expectedId: addedDriveId);
      sqliteDb.mockQuery(expectedResult: [addedDriveJson]);
      dateTimeMapper.mockMapFromDateAndTimeStrings(
        expectedDateTime: startDateTime,
      );

      final DriveSqliteDto? driveSqliteDto = await service.insert(
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );

      expect(driveSqliteDto, expectedDriveSqliteDto);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verifyTableCreation();
      verify(
        () => sqliteDb.insert(
          tableName: tableName,
          values: driveToAddJson,
        ),
      ).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [addedDriveId],
        ),
      ).called(1);
    },
  );

  test(
    'insert, '
    'should not create table if it already exists in db, should insert passed '
    'values to table and should return DriveSqliteDto object',
    () async {
      const int addedDriveId = 1;
      final DateTime startDateTime = DateTime(2024, 8, 20, 2, 30);
      const String startDateStr = '2024-08-20';
      const String startTimeStr = '02:30';
      const double distanceInKm = 22.22;
      const Duration duration = Duration(minutes: 25, seconds: 30);
      final Map<String, Object> driveToAddJson = {
        startDateColName: startDateStr,
        startTimeColName: startTimeStr,
        distanceColName: distanceInKm,
        durationColName: duration.inSeconds,
      };
      final Map<String, Object> addedDriveJson = {
        idColName: addedDriveId,
        ...driveToAddJson,
      };
      final DriveSqliteDto expectedDriveSqliteDto = DriveSqliteDto(
        id: addedDriveId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );
      sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
      dateTimeMapper.mockMapToDateString(expectedDateStr: startDateStr);
      dateTimeMapper.mockMapToTimeString(expectedTimeStr: startTimeStr);
      sqliteDb.mockInsert(expectedId: addedDriveId);
      sqliteDb.mockQuery(expectedResult: [addedDriveJson]);
      dateTimeMapper.mockMapFromDateAndTimeStrings(
        expectedDateTime: startDateTime,
      );

      final DriveSqliteDto? driveSqliteDto = await service.insert(
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );

      expect(driveSqliteDto, expectedDriveSqliteDto);
      verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      verify(
        () => sqliteDb.insert(
          tableName: tableName,
          values: driveToAddJson,
        ),
      ).called(1);
      verify(
        () => sqliteDb.query(
          tableName: tableName,
          where: '$idColName = ?',
          whereArgs: [addedDriveId],
        ),
      ).called(1);
    },
  );
}
