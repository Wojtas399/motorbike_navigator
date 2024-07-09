import 'package:injectable/injectable.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/drive.dart';
import '../../dto/coordinates_dto.dart';
import '../../dto/drive_dto.dart';
import '../../firebase/firebase_drive_service.dart';
import '../../mapper/drive_mapper.dart';
import '../repository.dart';
import 'drive_repository.dart';

@LazySingleton(as: DriveRepository)
class DriveRepositoryImpl extends Repository<Drive> implements DriveRepository {
  final FirebaseDriveService _dbDriveService;

  DriveRepositoryImpl(
    this._dbDriveService,
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
  Future<void> addDrive({
    required String userId,
    required double distanceInKm,
    required int durationInSeconds,
    required double avgSpeedInKmPerH,
    required List<Coordinates> waypoints,
  }) async {
    final List<CoordinatesDto> waypointDtos = waypoints
        .map(
          (waypoint) => CoordinatesDto(
            lat: waypoint.latitude,
            long: waypoint.longitude,
          ),
        )
        .toList();
    final DriveDto? addedDriveDto = await _dbDriveService.addDrive(
      userId: userId,
      distanceInKm: distanceInKm,
      durationInSeconds: durationInSeconds,
      avgSpeedInKmPerH: avgSpeedInKmPerH,
      waypoints: waypointDtos,
    );
    if (addedDriveDto == null) {
      throw '[DriveRepository] Cannot add new drive to db';
    }
    final Drive addedDrive = mapDriveFromDto(addedDriveDto);
    addEntity(addedDrive);
  }

  Future<void> _fetchAllUserDrives(String userId) async {
    final List<DriveDto> driveDtos =
        await _dbDriveService.fetchAllUserDrives(userId: userId);
    if (driveDtos.isEmpty) return;
    final List<Drive> drives = driveDtos.map(mapDriveFromDto).toList();
    addEntities(drives);
  }
}
