import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/model/sql_column.dart';
import 'package:motorbike_navigator/data/local_db/service/drive_sqlite_service.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

import '../../../creator/drive_creator.dart';
import '../../../mock/data/local_db/mock_sqlite_db.dart';
import '../../../mock/data/mapper/mock_datetime_mapper.dart';

void main() {
  const String tableName = 'Drives';
  const String idColName = 'id';
  const String titleColName = 'title';
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
            name: titleColName,
            type: SqlColumnType.text,
            isNotNull: true,
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

  group(
    'queryById, ',
    () {
      const int driveId = 1;
      final driveCreator = DriveCreator(
        id: driveId,
        title: 'drive title',
        startDateTime: DateTime(2024, 8, 20, 2, 5),
        distanceInKm: 22.22,
        duration: const Duration(minutes: 33, seconds: 20),
      );

      tearDown(() {
        verify(
          () => sqliteDb.query(
            tableName: tableName,
            where: '$idColName = ?',
            whereArgs: [driveId],
          ),
        ).called(1);
        verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
      });

      test(
        'should create table if it does not exist in db and should return '
        'DriveSqliteDto object if drive with passed id exists in table',
        () async {
          final Map<String, Object?> driveJson = driveCreator.createJson();
          final DriveSqliteDto expectedDriveSqliteDto =
              driveCreator.createSqliteDto();
          sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
          sqliteDb.mockCreateTable();
          sqliteDb.mockQuery(expectedResult: [driveJson]);
          dateTimeMapper.mockMapFromDateAndTimeStrings(
            expectedDateTime: expectedDriveSqliteDto.startDateTime,
          );

          final DriveSqliteDto? driveSqliteDto =
              await service.queryById(id: driveId);

          expect(driveSqliteDto, expectedDriveSqliteDto);
          verifyTableCreation();
        },
      );

      test(
        'should not create table if it already exists in db and should return '
        'DriveSqliteDto object if drive with passed id exists in table',
        () async {
          final Map<String, Object?> driveJson = driveCreator.createJson();
          final DriveSqliteDto expectedDriveSqliteDto =
              driveCreator.createSqliteDto();
          sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
          sqliteDb.mockQuery(expectedResult: [driveJson]);
          dateTimeMapper.mockMapFromDateAndTimeStrings(
            expectedDateTime: expectedDriveSqliteDto.startDateTime,
          );

          final DriveSqliteDto? driveSqliteDto =
              await service.queryById(id: driveId);

          expect(driveSqliteDto, expectedDriveSqliteDto);
        },
      );

      test(
        'should return null if drive with passed id does not exist in table',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
          sqliteDb.mockQuery(expectedResult: []);

          final DriveSqliteDto? driveSqliteDto =
              await service.queryById(id: driveId);

          expect(driveSqliteDto, null);
        },
      );
    },
  );

  group(
    'queryAll, ',
    () {
      final driveCreators = [
        DriveCreator(id: 1),
        DriveCreator(id: 2),
        DriveCreator(id: 3),
      ];
      final List<Map<String, Object?>> allDriveJsons =
          driveCreators.map((creator) => creator.createJson()).toList();
      final List<DriveSqliteDto> expectedAllDriveSqliteDtos =
          driveCreators.map((creator) => creator.createSqliteDto()).toList();

      setUp(() {
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
      });

      tearDown(() {
        verify(() => sqliteDb.doesTableNotExist(tableName)).called(1);
        verify(
          () => sqliteDb.query(tableName: tableName),
        ).called(1);
      });

      test(
        'should create table if it does not exist in db, should query all '
        'drives from table and should return them',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
          sqliteDb.mockCreateTable();

          final List<DriveSqliteDto> allDriveSqliteDtos =
              await service.queryAll();

          expect(allDriveSqliteDtos, expectedAllDriveSqliteDtos);
          verifyTableCreation();
        },
      );

      test(
        'should not create table if it already exists in db, should query all '
        'drives from table and should return them',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: false);

          final List<DriveSqliteDto> allDriveSqliteDtos =
              await service.queryAll();

          expect(allDriveSqliteDtos, expectedAllDriveSqliteDtos);
        },
      );
    },
  );

  group(
    'queryByDateRange, ',
    () {
      final DateTime firstDateOfRange = DateTime(2024, 8, 20);
      final DateTime lastDateOfRange = DateTime(2024, 8, 21);
      const String firstDateOfRangeStr = '2024-08-20';
      const String lastDateOfRangeStr = '2024-08-21';
      final driveCreators = [
        DriveCreator(id: 1),
        DriveCreator(id: 2),
      ];
      final List<Map<String, Object?>> driveJsons = [
        driveCreators.first.createJson(),
        driveCreators.last.createJson(),
      ];
      final List<DriveSqliteDto> expectedDriveSqliteDtos = [
        driveCreators.first.createSqliteDto(),
        driveCreators.last.createSqliteDto(),
      ];

      setUp(() {
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
      });

      tearDown(() {
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
      });

      test(
        'queryByDateRange, '
        'should create table if it does not exist in db, should query drives which '
        'started between passed date range and should return them',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
          sqliteDb.mockCreateTable();

          final List<DriveSqliteDto> driveSqliteDtos =
              await service.queryByDateRange(
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(driveSqliteDtos, expectedDriveSqliteDtos);
          verifyTableCreation();
        },
      );

      test(
        'queryByDateRange, '
        'should not create table if it already exists in db, should query drives '
        'which started between passed date range and should return them',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: false);

          final List<DriveSqliteDto> driveSqliteDtos =
              await service.queryByDateRange(
            firstDateOfRange: firstDateOfRange,
            lastDateOfRange: lastDateOfRange,
          );

          expect(driveSqliteDtos, expectedDriveSqliteDtos);
        },
      );
    },
  );

  group(
    'insert, ',
    () {
      const int addedDriveId = 1;
      const String title = 'title';
      final DateTime startDateTime = DateTime(2024, 8, 20, 2, 30);
      const String startDateStr = '2024-08-20';
      const String startTimeStr = '02:30';
      const double distanceInKm = 22.22;
      const Duration duration = Duration(minutes: 25, seconds: 30);
      final Map<String, Object> driveToAddJson = {
        titleColName: title,
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
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );

      setUp(() {
        dateTimeMapper.mockMapToDateString(expectedDateStr: startDateStr);
        dateTimeMapper.mockMapToTimeString(expectedTimeStr: startTimeStr);
        sqliteDb.mockInsert(expectedId: addedDriveId);
        sqliteDb.mockQuery(expectedResult: [addedDriveJson]);
        dateTimeMapper.mockMapFromDateAndTimeStrings(
          expectedDateTime: startDateTime,
        );
      });

      tearDown(() {
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
      });

      test(
        'should create table if it does not exist in db, should insert passed '
        'values to table and should return DriveSqliteDto object',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: true);
          sqliteDb.mockCreateTable();

          final DriveSqliteDto? driveSqliteDto = await service.insert(
            title: title,
            startDateTime: startDateTime,
            distanceInKm: distanceInKm,
            duration: duration,
          );

          expect(driveSqliteDto, expectedDriveSqliteDto);
          verifyTableCreation();
        },
      );

      test(
        'should not create table if it already exists in db, should insert '
        'passed values to table and should return DriveSqliteDto object',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: false);

          final DriveSqliteDto? driveSqliteDto = await service.insert(
            title: title,
            startDateTime: startDateTime,
            distanceInKm: distanceInKm,
            duration: duration,
          );

          expect(driveSqliteDto, expectedDriveSqliteDto);
        },
      );
    },
  );

  group(
    'deleteById, ',
    () {
      const int id = 1;

      test(
        'should do nothing if table does not exist',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: true);

          await service.deleteById(id: id);
        },
      );

      test(
        'should call method to delete drive from table',
        () async {
          sqliteDb.mockDoesTableNotExist(expectedAnswer: false);
          sqliteDb.mockDelete();

          await service.deleteById(id: id);

          verify(
            () => sqliteDb.delete(
              tableName: tableName,
              where: '$idColName = ?',
              whereArgs: [id],
            ),
          ).called(1);
        },
      );
    },
  );
}
