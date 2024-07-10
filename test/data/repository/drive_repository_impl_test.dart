import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/repository/drive/drive_repository_impl.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

import '../../creator/drive_creator.dart';
import '../../creator/drive_dto_creator.dart';
import '../../mock/data/firebase/mock_firebase_drive_service.dart';
import '../../mock/data/mapper/mock_drive_mapper.dart';

void main() {
  final dbDriveService = MockFirebaseDriveService();
  final driveMapper = MockDriveMapper();
  final driveCreator = DriveCreator();
  final driveDtoCreator = DriveDtoCreator();
  late DriveRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = DriveRepositoryImpl(dbDriveService, driveMapper);
  });

  tearDown(() {
    reset(dbDriveService);
    reset(driveMapper);
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
        driveCreator.create(id: 'd1', userId: userId),
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
    'addDrive, '
    'should call method to add drive to db and should add added drive to repo '
    'state',
    () async {
      const String id = 'd1';
      const String userId = 'u1';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 2.2;
      const int durationInSeconds = 50000;
      const double avgSpeedInKmPerH = 10.2;
      const List<Coordinates> waypoints = [
        Coordinates(50, 19),
        Coordinates(51, 20),
      ];
      const List<CoordinatesDto> waypointDtos = [
        CoordinatesDto(latitude: 50, longitude: 19),
        CoordinatesDto(latitude: 51, longitude: 20),
      ];
      final DriveDto addedDriveDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypointDtos,
      );
      final Drive expectedAddedDrive = Drive(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );
      final List<Drive> existingDrives = [
        driveCreator.create(id: 'd2', userId: userId),
        driveCreator.create(id: 'd3', userId: 'u2'),
      ];
      final List<Drive> expectedRepoState = [
        ...existingDrives,
        expectedAddedDrive,
      ];
      dbDriveService.mockAddDrive(expectedAddedDriveDto: addedDriveDto);
      driveMapper.mockMapFromDto(expectedDrive: expectedAddedDrive);
      repositoryImpl.addEntities(existingDrives);

      await repositoryImpl.addDrive(
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
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
          durationInSeconds: durationInSeconds,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          waypoints: waypointDtos,
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
      const int durationInSeconds = 50000;
      const double avgSpeedInKmPerH = 10.2;
      const List<Coordinates> waypoints = [
        Coordinates(50, 19),
        Coordinates(51, 20),
      ];
      const List<CoordinatesDto> waypointDtos = [
        CoordinatesDto(latitude: 50, longitude: 19),
        CoordinatesDto(latitude: 51, longitude: 20),
      ];
      const String expectedException =
          '[DriveRepository] Cannot add new drive to db';
      dbDriveService.mockAddDrive(expectedAddedDriveDto: null);

      Object? exception;
      try {
        await repositoryImpl.addDrive(
          userId: userId,
          startDateTime: startDateTime,
          distanceInKm: distanceInKm,
          durationInSeconds: durationInSeconds,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          waypoints: waypoints,
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
          durationInSeconds: durationInSeconds,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          waypoints: waypointDtos,
        ),
      ).called(1);
    },
  );
}
