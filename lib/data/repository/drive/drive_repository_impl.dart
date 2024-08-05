import 'package:injectable/injectable.dart';

import '../../../entity/drive.dart';
import '../../../entity/position.dart';
import '../../../ui/service/date_service.dart';
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
  Stream<List<Drive>> getAllDrives() async* {
    await _fetchAllDrives();
    await for (final drives in repositoryState$) {
      yield drives;
    }
  }

  @override
  Stream<List<Drive>> getDrivesFromDateRange({
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) async* {
    await _fetchDrivesFromDateRange(
      firstDateOfRange,
      lastDateOfRange,
    );
    await for (final drives in repositoryState$) {
      final List<Drive> userDrives = drives
          .where(
            (Drive drive) => _dateService.isDateFromRange(
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
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required List<Position> positions,
  }) async {
    //TODO: We should add drives to sqlite
    // final List<PositionDto> positionDtos =
    //     positions.map(_positionMapper.mapToDto).toList();
    // final DriveDto? addedDriveDto = await _dbDriveService.addDrive(
    //   userId: userId,
    //   startDateTime: startDateTime,
    //   distanceInKm: distanceInKm,
    //   duration: duration,
    //   positions: positionDtos,
    // );
    // if (addedDriveDto == null) {
    //   throw '[DriveRepository] Cannot add new drive to db';
    // }
    // final Drive addedDrive = _driveMapper.mapFromDto(addedDriveDto);
    // addEntity(addedDrive);
  }

  Future<void> _fetchAllDrives() async {
    //TODO: We should fetch all drives from sqlite
    // final List<DriveDto> driveDtos =
    //     await _dbDriveService.fetchAllUserDrives(userId: userId);
    // if (driveDtos.isEmpty) return;
    // final List<Drive> drives = driveDtos.map(_driveMapper.mapFromDto).toList();
    // addEntities(drives);
  }

  Future<void> _fetchDrivesFromDateRange(
    DateTime firstDateOfRange,
    DateTime lastDateOfRange,
  ) async {
    //TODO: We should fetch drives from date range from sqlite
    // final List<DriveDto> driveDtos =
    //     await _dbDriveService.fetchAllUserDrivesFromDateRange(
    //   userId: userId,
    //   firstDateOfRange: firstDateOfRange,
    //   lastDateOfRange: lastDateOfRange,
    // );
    // if (driveDtos.isEmpty) return;
    // final List<Drive> drives = driveDtos.map(_driveMapper.mapFromDto).toList();
    // addEntities(drives);
  }
}
