import 'package:injectable/injectable.dart';

import '../../../entity/drive.dart';
import '../../../entity/position.dart';
import '../../../ui/service/date_service.dart';
import '../../dto/drive_dto.dart';
import '../../dto/position_dto.dart';
import '../../firebase/firebase_drive_service.dart';
import '../../mapper/drive_mapper.dart';
import '../../mapper/position_mapper.dart';
import '../repository.dart';
import 'drive_repository.dart';

@LazySingleton(as: DriveRepository)
class DriveRepositoryImpl extends Repository<Drive> implements DriveRepository {
  final FirebaseDriveService _dbDriveService;
  final DriveMapper _driveMapper;
  final PositionMapper _positionMapper;
  final DateService _dateService;

  DriveRepositoryImpl(
    this._dbDriveService,
    this._driveMapper,
    this._positionMapper,
    this._dateService,
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
  Stream<List<Drive>> getUserDrivesFromDateRange({
    required String userId,
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) async* {
    await _fetchUserDrivesFromDateRange(
      userId,
      firstDateOfRange,
      lastDateOfRange,
    );
    await for (final drives in repositoryState$) {
      final List<Drive> userDrives = drives
          .where(
            (Drive drive) =>
                drive.userId == userId &&
                _dateService.isDateFromRange(
                  date: drive.startDateTime,
                  firstDateOfRange: firstDateOfRange,
                  lastDateOfRange: lastDateOfRange,
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
    required List<Position> positions,
  }) async {
    final List<PositionDto> positionDtos =
        positions.map(_positionMapper.mapToDto).toList();
    final DriveDto? addedDriveDto = await _dbDriveService.addDrive(
      userId: userId,
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
      positions: positionDtos,
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

  Future<void> _fetchUserDrivesFromDateRange(
    String userId,
    DateTime firstDateOfRange,
    DateTime lastDateOfRange,
  ) async {
    final List<DriveDto> driveDtos =
        await _dbDriveService.fetchAllUserDrivesFromDateRange(
      userId: userId,
      firstDateOfRange: firstDateOfRange,
      lastDateOfRange: lastDateOfRange,
    );
    if (driveDtos.isEmpty) return;
    final List<Drive> drives = driveDtos.map(_driveMapper.mapFromDto).toList();
    addEntities(drives);
  }
}
