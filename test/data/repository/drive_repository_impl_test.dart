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
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      final List<DriveDto> user1DriveDtos = [
        createDriveDto(id: 'd10', userId: user1Id),
        createDriveDto(id: 'd11', userId: user1Id),
      ];
      final List<DriveDto> user2DriveDtos = [
        createDriveDto(id: 'd20', userId: user2Id),
        createDriveDto(id: 'd21', userId: user2Id),
      ];
      final List<Drive> user1ExpectedDrives = [
        createDrive(id: 'd10', userId: user1Id),
        createDrive(id: 'd11', userId: user1Id),
      ];
      final List<Drive> user2ExpectedDrives = [
        createDrive(id: 'd20', userId: user2Id),
        createDrive(id: 'd21', userId: user2Id),
      ];
      final List<Drive> expectedRepositoryState = [
        createDrive(id: 'd10', userId: user1Id),
        createDrive(id: 'd11', userId: user1Id),
        createDrive(id: 'd20', userId: user2Id),
        createDrive(id: 'd21', userId: user2Id),
      ];
      when(
        () => dbDriveService.fetchAllUserDrives(userId: user1Id),
      ).thenAnswer((_) => Future.value(user1DriveDtos));
      when(
        () => dbDriveService.fetchAllUserDrives(userId: user2Id),
      ).thenAnswer((_) => Future.value(user2DriveDtos));
      when(
        () => driveMapper.mapFromDto(user1DriveDtos.first),
      ).thenReturn(user1ExpectedDrives.first);
      when(
        () => driveMapper.mapFromDto(user1DriveDtos.last),
      ).thenReturn(user1ExpectedDrives.last);
      when(
        () => driveMapper.mapFromDto(user2DriveDtos.first),
      ).thenReturn(user2ExpectedDrives.first);
      when(
        () => driveMapper.mapFromDto(user2DriveDtos.last),
      ).thenReturn(user2ExpectedDrives.last);

      final Stream<List<Drive>> allUser1Drives$ =
          repositoryImpl.getAllUserDrives(
        userId: user1Id,
      );
      await repositoryImpl.repositoryState$.first;
      final Stream<List<Drive>> allUser2Drives$ =
          repositoryImpl.getAllUserDrives(
        userId: user2Id,
      );
      await repositoryImpl.repositoryState$.first;

      expect(await allUser1Drives$.first, user1ExpectedDrives);
      expect(await allUser2Drives$.first, user2ExpectedDrives);
      expect(
        await repositoryImpl.repositoryState$.first,
        expectedRepositoryState,
      );
      verify(
        () => dbDriveService.fetchAllUserDrives(userId: user1Id),
      ).called(1);
      verify(
        () => dbDriveService.fetchAllUserDrives(userId: user2Id),
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
      const double distanceInKm = 2.2;
      const int durationInSeconds = 50000;
      const double avgSpeedInKmPerH = 10.2;
      const List<Coordinates> waypoints = [
        Coordinates(50, 19),
        Coordinates(51, 20),
      ];
      const List<CoordinatesDto> waypointDtos = [
        CoordinatesDto(lat: 50, long: 19),
        CoordinatesDto(lat: 51, long: 20),
      ];
      const DriveDto addedDriveDto = DriveDto(
        id: id,
        userId: userId,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypointDtos,
      );
      const Drive expectedAddedDrive = Drive(
        id: id,
        userId: userId,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );
      dbDriveService.mockAddDrive(expectedAddedDriveDto: addedDriveDto);
      driveMapper.mockMapFromDto(expectedDrive: expectedAddedDrive);

      await repositoryImpl.addDrive(
        userId: userId,
        distanceInKm: distanceInKm,
        durationInSeconds: durationInSeconds,
        avgSpeedInKmPerH: avgSpeedInKmPerH,
        waypoints: waypoints,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        [expectedAddedDrive],
      );
      verify(
        () => dbDriveService.addDrive(
          userId: userId,
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
      const double distanceInKm = 2.2;
      const int durationInSeconds = 50000;
      const double avgSpeedInKmPerH = 10.2;
      const List<Coordinates> waypoints = [
        Coordinates(50, 19),
        Coordinates(51, 20),
      ];
      const List<CoordinatesDto> waypointDtos = [
        CoordinatesDto(lat: 50, long: 19),
        CoordinatesDto(lat: 51, long: 20),
      ];
      const String expectedException =
          '[DriveRepository] Cannot add new drive to db';
      dbDriveService.mockAddDrive(expectedAddedDriveDto: null);

      Object? exception;
      try {
        await repositoryImpl.addDrive(
          userId: userId,
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
          distanceInKm: distanceInKm,
          durationInSeconds: durationInSeconds,
          avgSpeedInKmPerH: avgSpeedInKmPerH,
          waypoints: waypointDtos,
        ),
      ).called(1);
    },
  );
}
