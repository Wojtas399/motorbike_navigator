import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/local_db/dto/position_sqlite_dto.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository_impl.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../../creator/drive_creator.dart';
import '../../creator/drive_sqlite_dto_creator.dart';
import '../../mock/data/local_db/mock_drive_sqlite_service.dart';
import '../../mock/data/local_db/mock_position_sqlite_service.dart';
import '../../mock/data/mapper/mock_drive_mapper.dart';
import '../../mock/ui_service/mock_date_service.dart';

void main() {
  final driveSqliteService = MockDriveSqliteService();
  final positionSqliteService = MockPositionSqliteService();
  final driveMapper = MockDriveMapper();
  final dateService = MockDateService();
  final driveCreator = DriveCreator();
  final driveSqliteDtoCreator = DriveSqliteDtoCreator();
  late DriveRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = DriveRepositoryImpl(
      driveSqliteService,
      positionSqliteService,
      driveMapper,
      dateService,
    );
  });

  tearDown(() {
    reset(driveSqliteService);
    reset(positionSqliteService);
    reset(driveMapper);
    reset(dateService);
  });

  group(
    'getDriveById, ',
    () {
      const int id = 1;
      final Drive expectedDrive = driveCreator.create(id: id);

      test(
        'should emit null if drive with matching id does not exist in repo '
        'state and in db',
        () async {
          driveSqliteService.mockQueryById();

          final Stream<Drive?> drive$ = repositoryImpl.getDriveById(id);

          expect(await drive$.first, null);
        },
      );

      test(
        'should emit drive with matching id if it already exists in repo state',
        () async {
          repositoryImpl.addEntity(expectedDrive);

          final Stream<Drive?> drive$ = repositoryImpl.getDriveById(id);

          expect(await drive$.first, expectedDrive);
        },
      );

      test(
        'should fetch drive from db, add it to repo state and emit it if it '
        'does not exist in repo state',
        () async {
          final DriveSqliteDto driveSqliteDto = driveSqliteDtoCreator.create(
            id: id,
          );
          driveSqliteService.mockQueryById(
            expectedDriveSqliteDto: driveSqliteDto,
          );
          positionSqliteService.mockQueryByDriveId(
            expectedPositionSqliteDtos: [],
          );
          driveMapper.mockMapFromDto(expectedDrive: expectedDrive);

          final Stream<Drive?> drive$ = repositoryImpl.getDriveById(id);

          expect(await drive$.first, expectedDrive);
          expect(await repositoryImpl.repositoryState$.first, [expectedDrive]);
        },
      );
    },
  );

  test(
    'getAllDrives, '
    'should fetch all drives from db, add them to repo state and emit them all',
    () async {
      final List<DriveSqliteDto> fetchedDriveSqliteDtos = [
        driveSqliteDtoCreator.create(id: 3),
        driveSqliteDtoCreator.create(id: 4),
      ];
      final List<Drive> fetchedDrives = [
        driveCreator.create(id: 3),
        driveCreator.create(id: 4),
      ];
      final List<Drive> existingDrives = [
        driveCreator.create(id: 1),
        driveCreator.create(id: 2),
        driveCreator.create(id: 5),
      ];
      final List<Drive> expectedDrives = [
        ...existingDrives,
        ...fetchedDrives,
      ];
      final List<Drive> expectedRepositoryState = [
        ...existingDrives,
        ...fetchedDrives
      ];
      driveSqliteService.mockQueryAll(
        expectedDriveSqliteDtos: fetchedDriveSqliteDtos,
      );
      when(
        () => positionSqliteService.queryByDriveId(driveId: 3),
      ).thenAnswer((_) => Future.value([]));
      when(
        () => positionSqliteService.queryByDriveId(driveId: 4),
      ).thenAnswer((_) => Future.value([]));
      when(
        () => driveMapper.mapFromDto(
          driveDto: fetchedDriveSqliteDtos.first,
          positionDtos: [],
        ),
      ).thenReturn(fetchedDrives.first);
      when(
        () => driveMapper.mapFromDto(
          driveDto: fetchedDriveSqliteDtos.last,
          positionDtos: [],
        ),
      ).thenReturn(fetchedDrives.last);
      repositoryImpl.addEntities(existingDrives);

      final Stream<List<Drive>> allDrives$ = repositoryImpl.getAllDrives();

      expect(await allDrives$.first, expectedDrives);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepositoryState,
      );
      verify(driveSqliteService.queryAll).called(1);
      verify(() => positionSqliteService.queryByDriveId(driveId: 3)).called(1);
      verify(() => positionSqliteService.queryByDriveId(driveId: 4)).called(1);
    },
  );

  test(
    'getUserDrivesFromDateRange, '
    'should fetch from db drives which startDateTime is from given date range, '
    'should add them to repo state and should emit all drives with matching '
    'startDateTime',
    () async {
      final DateTime firstDateOfRange = DateTime(2024, 7, 22);
      final DateTime lastDateOfRange = DateTime(2024, 7, 28);
      final List<DriveSqliteDto> fetchedDriveSqliteDtos = [
        driveSqliteDtoCreator.create(
          id: 3,
          startDateTime: DateTime(2024, 7, 23),
        ),
        driveSqliteDtoCreator.create(
          id: 4,
          startDateTime: DateTime(2024, 7, 25),
        ),
      ];
      final List<Drive> fetchedDrives = [
        driveCreator.create(
          id: 3,
          startDateTime: DateTime(2024, 7, 23),
        ),
        driveCreator.create(
          id: 4,
          startDateTime: DateTime(2024, 7, 25),
        ),
      ];
      final List<Drive> existingDrives = [
        driveCreator.create(
          id: 1,
          startDateTime: DateTime(2024, 7, 27),
        ),
        driveCreator.create(id: 2),
        driveCreator.create(
          id: 5,
          startDateTime: DateTime(2024, 7, 29),
        ),
      ];
      final List<Drive> expectedDrives = [
        existingDrives.first,
        ...fetchedDrives,
      ];
      final List<Drive> expectedRepositoryState = [
        ...existingDrives,
        ...fetchedDrives
      ];
      driveSqliteService.mockQueryByDateRange(
        expectedDriveSqliteDtos: fetchedDriveSqliteDtos,
      );
      positionSqliteService.mockQueryByDriveId(
        expectedPositionSqliteDtos: [],
      );
      when(
        () => driveMapper.mapFromDto(
          driveDto: fetchedDriveSqliteDtos.first,
          positionDtos: [],
        ),
      ).thenReturn(fetchedDrives.first);
      when(
        () => driveMapper.mapFromDto(
          driveDto: fetchedDriveSqliteDtos.last,
          positionDtos: [],
        ),
      ).thenReturn(fetchedDrives.last);
      dateService.mockIsDateFromRange(
        expectedAnswer: false,
      );
      when(
        () => dateService.isDateFromRange(
          date: fetchedDrives.first.startDateTime,
          firstDateOfRange: firstDateOfRange,
          lastDateOfRange: lastDateOfRange,
        ),
      ).thenReturn(true);
      when(
        () => dateService.isDateFromRange(
          date: fetchedDrives.last.startDateTime,
          firstDateOfRange: firstDateOfRange,
          lastDateOfRange: lastDateOfRange,
        ),
      ).thenReturn(true);
      when(
        () => dateService.isDateFromRange(
          date: existingDrives.first.startDateTime,
          firstDateOfRange: firstDateOfRange,
          lastDateOfRange: lastDateOfRange,
        ),
      ).thenReturn(true);
      repositoryImpl.addEntities(existingDrives);

      final Stream<List<Drive>> allDrives$ =
          repositoryImpl.getDrivesFromDateRange(
        firstDateOfRange: firstDateOfRange,
        lastDateOfRange: lastDateOfRange,
      );

      expect(await allDrives$.first, expectedDrives);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepositoryState,
      );
      verify(
        () => driveSqliteService.queryByDateRange(
          firstDateOfRange: firstDateOfRange,
          lastDateOfRange: lastDateOfRange,
        ),
      ).called(1);
    },
  );

  test(
    'addDrive, '
    'should call methods to add drive and its positions to db and should add '
    'added drive to repo state',
    () async {
      const int driveId = 1;
      const String title = 'title';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 2.2;
      const Duration duration = Duration(minutes: 20);
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(51, 20),
          elevation: 110.1,
          speedInKmPerH: 33.33,
        ),
        Position(
          coordinates: Coordinates(50, 19),
          elevation: 100.1,
          speedInKmPerH: 22.22,
        ),
      ];
      const List<PositionSqliteDto> positionSqliteDtos = [
        PositionSqliteDto(
          id: 1,
          driveId: driveId,
          order: 1,
          latitude: 51,
          longitude: 20,
          elevation: 110.1,
          speedInKmPerH: 33.33,
        ),
        PositionSqliteDto(
          id: 2,
          driveId: driveId,
          order: 2,
          latitude: 50,
          longitude: 19,
          elevation: 100.1,
          speedInKmPerH: 22.2,
        ),
      ];
      final DriveSqliteDto addedDriveSqliteDto = DriveSqliteDto(
        id: driveId,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );
      final Drive expectedAddedDrive = Drive(
        id: driveId,
        title: '',
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );
      final List<Drive> existingDrives = [
        driveCreator.create(id: 2),
        driveCreator.create(id: 3),
      ];
      final List<Drive> expectedRepoState = [
        ...existingDrives,
        expectedAddedDrive,
      ];
      driveSqliteService.mockInsert(
        expectedInsertedDriveSqliteDto: addedDriveSqliteDto,
      );
      when(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 1,
          latitude: positions.first.coordinates.latitude,
          longitude: positions.first.coordinates.longitude,
          elevation: positions.first.elevation,
          speedInKmPerH: positions.first.speedInKmPerH,
        ),
      ).thenAnswer((_) => Future.value(positionSqliteDtos.first));
      when(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 2,
          latitude: positions.last.coordinates.latitude,
          longitude: positions.last.coordinates.longitude,
          elevation: positions.last.elevation,
          speedInKmPerH: positions.last.speedInKmPerH,
        ),
      ).thenAnswer((_) => Future.value(positionSqliteDtos.last));
      driveMapper.mockMapFromDto(expectedDrive: expectedAddedDrive);
      repositoryImpl.addEntities(existingDrives);

      await repositoryImpl.addDrive(
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepoState,
      );
      verify(
        () => driveSqliteService.insert(
          title: title,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          duration: duration,
        ),
      ).called(1);
      verify(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 1,
          latitude: positions.first.coordinates.latitude,
          longitude: positions.first.coordinates.longitude,
          elevation: positions.first.elevation,
          speedInKmPerH: positions.first.speedInKmPerH,
        ),
      ).called(1);
      verify(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 2,
          latitude: positions.last.coordinates.latitude,
          longitude: positions.last.coordinates.longitude,
          elevation: positions.last.elevation,
          speedInKmPerH: positions.last.speedInKmPerH,
        ),
      ).called(1);
    },
  );

  test(
    'addDrive, '
    'method to add drive to db returns null, '
    'should finish method call',
    () async {
      const String title = 'title';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 2.2;
      const Duration duration = Duration(minutes: 20);
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50, 19),
          elevation: 100.1,
          speedInKmPerH: 22.2,
        ),
        Position(
          coordinates: Coordinates(51, 20),
          elevation: 110.1,
          speedInKmPerH: 33.33,
        ),
      ];
      driveSqliteService.mockInsert(expectedInsertedDriveSqliteDto: null);

      await repositoryImpl.addDrive(
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );

      verify(
        () => driveSqliteService.insert(
          title: title,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          duration: duration,
        ),
      ).called(1);
    },
  );

  test(
    'addDrive, '
    'method to add position to db returns null, '
    'should omit position in list',
    () async {
      const int driveId = 1;
      const String title = 'title';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 2.2;
      const Duration duration = Duration(minutes: 20);
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(51, 20),
          elevation: 110.1,
          speedInKmPerH: 33.33,
        ),
        Position(
          coordinates: Coordinates(50, 19),
          elevation: 100.1,
          speedInKmPerH: 22.22,
        ),
      ];
      const List<PositionSqliteDto> positionSqliteDtos = [
        PositionSqliteDto(
          id: 1,
          driveId: driveId,
          order: 1,
          latitude: 51,
          longitude: 20,
          elevation: 110.1,
          speedInKmPerH: 33.33,
        ),
      ];
      final DriveSqliteDto addedDriveSqliteDto = DriveSqliteDto(
        id: driveId,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );
      final Drive expectedAddedDrive = Drive(
        id: driveId,
        title: '',
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: [positions.first],
      );
      final List<Drive> existingDrives = [
        driveCreator.create(id: 2),
        driveCreator.create(id: 3),
      ];
      final List<Drive> expectedRepoState = [
        ...existingDrives,
        expectedAddedDrive,
      ];
      driveSqliteService.mockInsert(
        expectedInsertedDriveSqliteDto: addedDriveSqliteDto,
      );
      when(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 1,
          latitude: positions.first.coordinates.latitude,
          longitude: positions.first.coordinates.longitude,
          elevation: positions.first.elevation,
          speedInKmPerH: positions.first.speedInKmPerH,
        ),
      ).thenAnswer((_) => Future.value(positionSqliteDtos.first));
      when(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 2,
          latitude: positions.last.coordinates.latitude,
          longitude: positions.last.coordinates.longitude,
          elevation: positions.last.elevation,
          speedInKmPerH: positions.last.speedInKmPerH,
        ),
      ).thenAnswer((_) => Future.value(null));
      driveMapper.mockMapFromDto(expectedDrive: expectedAddedDrive);
      repositoryImpl.addEntities(existingDrives);

      await repositoryImpl.addDrive(
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepoState,
      );
      verify(
        () => driveSqliteService.insert(
          title: title,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          duration: duration,
        ),
      ).called(1);
      verify(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 1,
          latitude: positions.first.coordinates.latitude,
          longitude: positions.first.coordinates.longitude,
          elevation: positions.first.elevation,
          speedInKmPerH: positions.first.speedInKmPerH,
        ),
      ).called(1);
      verify(
        () => positionSqliteService.insert(
          driveId: driveId,
          order: 2,
          latitude: positions.last.coordinates.latitude,
          longitude: positions.last.coordinates.longitude,
          elevation: positions.last.elevation,
          speedInKmPerH: positions.last.speedInKmPerH,
        ),
      ).called(1);
    },
  );
}
