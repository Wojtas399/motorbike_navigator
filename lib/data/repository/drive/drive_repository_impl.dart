import 'package:injectable/injectable.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/drive.dart';
import '../../../ui/service/date_time_service.dart';
import '../../dto/coordinates_dto.dart';
import '../../dto/drive_dto.dart';
import '../../firebase/firebase_drive_service.dart';
import '../../mapper/drive_mapper.dart';
import '../repository.dart';
import 'drive_repository.dart';

@LazySingleton(as: DriveRepository)
class DriveRepositoryImpl extends Repository<Drive> implements DriveRepository {
  final FirebaseDriveService _dbDriveService;
  final DriveMapper _driveMapper;
  final DateTimeService _dateTimeService;

  DriveRepositoryImpl(
    this._dbDriveService,
    this._driveMapper,
    this._dateTimeService,
  );

  @override
  Stream<List<Drive>> getAllUserDrives({
    required String userId,
  }) async* {
    await _fetchAllUserDrives(userId);
    await for (final drives in repositoryState$) {
      final List<Drive> userDrives =
          drives.where((drive) => drive.userId == userId).toList();
      yield userDrives;
    }
  }

  @override
  Stream<List<Drive>> getAllUserDrivesFromDateRange({
    required String userId,
    required DateTime firstDateTimeOfRange,
    required DateTime lastDateTimeOfRange,
  }) async* {
    await _fetchAllUserDrivesFromDateRange(
      userId,
      firstDateTimeOfRange,
      lastDateTimeOfRange,
    );
    await for (final drives in repositoryState$) {
      final List<Drive> userDrives = drives
          .where(
            (Drive drive) =>
                drive.userId == userId &&
                _dateTimeService.isDateTimeFromRange(
                  date: drive.startDateTime,
                  firstDateTimeOfRange: firstDateTimeOfRange,
                  lastDateTimeOfRange: lastDateTimeOfRange,
                ),
          )
          .toList();
      yield userDrives;
    }
  }

  @override
  Future<void> addDrive({
    required String userId,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required double avgSpeedInKmPerH,
    required List<Coordinates> waypoints,
  }) async {
    final List<CoordinatesDto> waypointDtos = waypoints
        .map(
          (waypoint) => CoordinatesDto(
            latitude: waypoint.latitude,
            longitude: waypoint.longitude,
          ),
        )
        .toList();
    final DriveDto? addedDriveDto = await _dbDriveService.addDrive(
      userId: userId,
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
      avgSpeedInKmPerH: avgSpeedInKmPerH,
      waypoints: waypointDtos,
    );
    if (addedDriveDto == null) {
      throw '[DriveRepository] Cannot add new drive to db';
    }
    final Drive addedDrive = _driveMapper.mapFromDto(addedDriveDto);
    addEntity(addedDrive);
  }

  Future<void> _fetchAllUserDrives(String userId) async {
    final List<DriveDto> driveDtos =
        await _dbDriveService.fetchAllUserDrives(userId: userId);
    if (driveDtos.isEmpty) return;
    final List<Drive> drives = driveDtos.map(_driveMapper.mapFromDto).toList();
    addEntities(drives);
  }

  Future<void> _fetchAllUserDrivesFromDateRange(
    String userId,
    DateTime firstDateTimeOfRange,
    DateTime lastDateTimeOfRange,
  ) async {
    final List<DriveDto> driveDtos =
        await _dbDriveService.fetchAllUserDrivesFromDateRange(
      userId: userId,
      firstDateTimeOfRange: firstDateTimeOfRange,
      lastDateTimeOfRange: lastDateTimeOfRange,
    );
    if (driveDtos.isEmpty) return;
    final List<Drive> drives = driveDtos.map(_driveMapper.mapFromDto).toList();
    addEntities(drives);
  }
}
