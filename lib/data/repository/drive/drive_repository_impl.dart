import 'package:injectable/injectable.dart';

import '../../../entity/drive.dart';
import '../../../entity/position.dart';
import '../../../ui/service/date_service.dart';
import '../../mapper/drive_mapper.dart';
import '../../sqlite/drive_sqlite_service.dart';
import '../../sqlite/dto/drive_sqlite_dto.dart';
import '../../sqlite/dto/position_sqlite_dto.dart';
import '../../sqlite/position_sqlite_service.dart';
import '../repository.dart';
import 'drive_repository.dart';

@LazySingleton(as: DriveRepository)
class DriveRepositoryImpl extends Repository<Drive> implements DriveRepository {
  final DriveSqliteService _driveSqliteService;
  final PositionSqliteService _positionSqliteService;
  final DriveMapper _driveMapper;
  final DateService _dateService;

  DriveRepositoryImpl(
    this._driveSqliteService,
    this._positionSqliteService,
    this._driveMapper,
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
    await _fetchDrivesFromDateRange(firstDateOfRange, lastDateOfRange);
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
    final addedDriveDto = await _driveSqliteService.insert(
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
    );
    if (addedDriveDto == null) return;
    final List<PositionSqliteDto> addedPositionDtos = [];
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final addedPosDto = await _positionSqliteService.insert(
        driveId: addedDriveDto.id,
        order: i + 1,
        latitude: pos.coordinates.latitude,
        longitude: pos.coordinates.longitude,
        altitude: pos.altitude,
        speedInKmPerH: pos.speedInKmPerH,
      );
      if (addedPosDto != null) addedPositionDtos.add(addedPosDto);
    }
    final Drive addedDrive = _driveMapper.mapFromDto(
      driveDto: addedDriveDto,
      positionDtos: addedPositionDtos,
    );
    addEntity(addedDrive);
  }

  Future<void> _fetchAllDrives() async {
    final List<DriveSqliteDto> driveDtos = await _driveSqliteService.queryAll();
    if (driveDtos.isEmpty) return;
    final List<Drive> drives = [];
    for (final driveDto in driveDtos) {
      final Drive drive = await _mapDriveSqliteDtoToDrive(driveDto);
      drives.add(drive);
    }
    addEntities(drives);
  }

  Future<void> _fetchDrivesFromDateRange(
    DateTime firstDateOfRange,
    DateTime lastDateOfRange,
  ) async {
    final List<DriveSqliteDto> driveDtos =
        await _driveSqliteService.queryByDateRange(
      firstDateOfRange: firstDateOfRange,
      lastDateOfRange: lastDateOfRange,
    );
    if (driveDtos.isEmpty) return;
    final List<Drive> drives = [];
    for (final driveDto in driveDtos) {
      final Drive drive = await _mapDriveSqliteDtoToDrive(driveDto);
      drives.add(drive);
    }
    addEntities(drives);
  }

  Future<Drive> _mapDriveSqliteDtoToDrive(DriveSqliteDto dto) async {
    final List<PositionSqliteDto> positionDtos =
        await _positionSqliteService.queryByDriveId(
      driveId: dto.id,
    );
    return _driveMapper.mapFromDto(
      driveDto: dto,
      positionDtos: positionDtos,
    );
  }
}
