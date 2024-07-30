import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/dto/position_dto.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository_impl.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../../creator/drive_creator.dart';
import '../../creator/drive_dto_creator.dart';
import '../../mock/data/firebase/mock_firebase_drive_service.dart';
import '../../mock/data/mapper/mock_drive_mapper.dart';
import '../../mock/data/mapper/mock_position_mapper.dart';
import '../../mock/ui_service/mock_date_service.dart';

void main() {
  final dbDriveService = MockFirebaseDriveService();
  final driveMapper = MockDriveMapper();
  final positionMapper = MockPositionMapper();
  final dateService = MockDateService();
  final driveCreator = DriveCreator();
  final driveDtoCreator = DriveDtoCreator();
  late DriveRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = DriveRepositoryImpl(
      dbDriveService,
      driveMapper,
      positionMapper,
      dateService,
    );
  });

  tearDown(() {
    reset(dbDriveService);
    reset(driveMapper);
    reset(positionMapper);
    reset(dateService);
  });

  test(
    'getAllUserDrives, '
    "should load all user's drives from db, add them to repo state and emit all "
    'drives with matching user id',
    () async {
      const String userId = 'u1';
      final List<DriveDto> fetchedDriveDtos = [
        driveDtoCreator.create(id: 'd3', userId: userId),
        driveDtoCreator.create(id: 'd4', userId: userId),
      ];
      final List<Drive> fetchedDrives = [
        driveCreator.create(id: 'd3', userId: userId),
        driveCreator.create(id: 'd4', userId: userId),
      ];
      final List<Drive> existingDrives = [
        driveCreator.create(id: 'd1', userId: userId),
        driveCreator.create(id: 'd2', userId: 'u2'),
        driveCreator.create(id: 'd5', userId: 'u3'),
      ];
      final List<Drive> expectedDrives = [
        existingDrives.first,
        ...fetchedDrives,
      ];
      final List<Drive> expectedRepositoryState = [
        ...existingDrives,
        ...fetchedDrives
      ];
      dbDriveService.mockFetchAllUserDrives(
        expectedDriveDtos: fetchedDriveDtos,
      );
      when(
        () => driveMapper.mapFromDto(fetchedDriveDtos.first),
      ).thenReturn(fetchedDrives.first);
      when(
        () => driveMapper.mapFromDto(fetchedDriveDtos.last),
      ).thenReturn(fetchedDrives.last);
      repositoryImpl.addEntities(existingDrives);

      final Stream<List<Drive>> allUserDrives$ =
          repositoryImpl.getAllUserDrives(userId: userId);

      expect(await allUserDrives$.first, expectedDrives);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepositoryState,
      );
      verify(
        () => dbDriveService.fetchAllUserDrives(userId: userId),
      ).called(1);
    },
  );

  test(
    'getUserDrivesFromDateRange, '
    "should load from db user's drives which startDateTime is from given "
    'date range, add them to repo state and should emit all drives with '
    'matching user id and startDateTime',
    () async {
      const String userId = 'u1';
      final DateTime firstDateOfRange = DateTime(2024, 7, 22);
      final DateTime lastDateOfRange = DateTime(2024, 7, 28);
      final List<DriveDto> fetchedDriveDtos = [
        driveDtoCreator.create(
          id: 'd3',
          userId: userId,
          startDateTime: DateTime(2024, 7, 23),
        ),
        driveDtoCreator.create(
          id: 'd4',
          userId: userId,
          startDateTime: DateTime(2024, 7, 25),
        ),
      ];
      final List<Drive> fetchedDrives = [
        driveCreator.create(
          id: 'd3',
          userId: userId,
          startDateTime: DateTime(2024, 7, 23),
        ),
        driveCreator.create(
          id: 'd4',
          userId: userId,
          startDateTime: DateTime(2024, 7, 25),
        ),
      ];
      final List<Drive> existingDrives = [
        driveCreator.create(
          id: 'd1',
          userId: userId,
          startDateTime: DateTime(2024, 7, 27),
        ),
        driveCreator.create(id: 'd2', userId: 'u2'),
        driveCreator.create(
          id: 'd5',
          userId: userId,
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
      dbDriveService.mockFetchAllUserDrivesFromDateRange(
        expectedDriveDtos: fetchedDriveDtos,
      );
      when(
        () => driveMapper.mapFromDto(fetchedDriveDtos.first),
      ).thenReturn(fetchedDrives.first);
      when(
        () => driveMapper.mapFromDto(fetchedDriveDtos.last),
      ).thenReturn(fetchedDrives.last);
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
      when(
        () => dateService.isDateFromRange(
          date: existingDrives.last.startDateTime,
          firstDateOfRange: firstDateOfRange,
          lastDateOfRange: lastDateOfRange,
        ),
      ).thenReturn(false);
      repositoryImpl.addEntities(existingDrives);

      final Stream<List<Drive>> allUserDrives$ =
          repositoryImpl.getUserDrivesFromDateRange(
        userId: userId,
        firstDateOfRange: firstDateOfRange,
        lastDateOfRange: lastDateOfRange,
      );

      expect(await allUserDrives$.first, expectedDrives);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepositoryState,
      );
      verify(
        () => dbDriveService.fetchAllUserDrivesFromDateRange(
          userId: userId,
          firstDateOfRange: firstDateOfRange,
          lastDateOfRange: lastDateOfRange,
        ),
      ).called(1);
    },
  );

  test(
    'addDrive, '
    'should call method to add drive to db and should add added drive to repo '
    'state',
    () async {
      const String id = 'd1';
      const String userId = 'u1';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 2.2;
      const Duration duration = Duration(minutes: 20);
      const double avgSpeedInKmPerH = 10.2;
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50, 19),
          altitude: 100.1,
          speedInKmPerH: 22.2,
        ),
        Position(
          coordinates: Coordinates(51, 20),
          altitude: 110.1,
          speedInKmPerH: 33.33,
        ),
      ];
      const List<PositionDto> positionDtos = [
        PositionDto(
          coordinates: CoordinatesDto(latitude: 50, longitude: 19),
          altitude: 100.1,
          speedInKmPerH: 22.2,
        ),
        PositionDto(
          coordinates: CoordinatesDto(latitude: 51, longitude: 20),
          altitude: 110.1,
          speedInKmPerH: 33.33,
        ),
      ];
      final DriveDto addedDriveDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positionDtos,
      );
      final Drive expectedAddedDrive = Drive(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positions,
      );
      final List<Drive> existingDrives = [
        driveCreator.create(id: 'd2', userId: userId),
        driveCreator.create(id: 'd3', userId: 'u2'),
      ];
      final List<Drive> expectedRepoState = [
        ...existingDrives,
        expectedAddedDrive,
      ];
      when(
        () => positionMapper.mapToDto(positions.first),
      ).thenReturn(positionDtos.first);
      when(
        () => positionMapper.mapToDto(positions.last),
      ).thenReturn(positionDtos.last);
      dbDriveService.mockAddDrive(expectedAddedDriveDto: addedDriveDto);
      driveMapper.mockMapFromDto(expectedDrive: expectedAddedDrive);
      repositoryImpl.addEntities(existingDrives);

      await repositoryImpl.addDrive(
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        positions: positions,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepoState,
      );
      verify(
        () => dbDriveService.addDrive(
          userId: userId,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          duration: duration,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          positions: positionDtos,
        ),
      ).called(1);
    },
  );

  test(
    'addDrive, '
    'method to add drive to db returns null, '
    'should throw exception',
    () async {
      const String userId = 'u1';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 2.2;
      const Duration duration = Duration(minutes: 20);
      const double avgSpeedInKmPerH = 10.2;
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50, 19),
          altitude: 100.1,
          speedInKmPerH: 22.2,
        ),
        Position(
          coordinates: Coordinates(51, 20),
          altitude: 110.1,
          speedInKmPerH: 33.33,
        ),
      ];
      const List<PositionDto> positionDtos = [
        PositionDto(
          coordinates: CoordinatesDto(latitude: 50, longitude: 19),
          altitude: 100.1,
          speedInKmPerH: 22.2,
        ),
        PositionDto(
          coordinates: CoordinatesDto(latitude: 51, longitude: 20),
          altitude: 110.1,
          speedInKmPerH: 33.33,
        ),
      ];
      const String expectedException =
          '[DriveRepository] Cannot add new drive to db';
      when(
        () => positionMapper.mapToDto(positions.first),
      ).thenReturn(positionDtos.first);
      when(
        () => positionMapper.mapToDto(positions.last),
      ).thenReturn(positionDtos.last);
      dbDriveService.mockAddDrive(expectedAddedDriveDto: null);

      Object? exception;
      try {
        await repositoryImpl.addDrive(
          userId: userId,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          duration: duration,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          positions: positions,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => dbDriveService.addDrive(
          userId: userId,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          duration: duration,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          positions: positionDtos,
        ),
      ).called(1);
    },
  );
}
