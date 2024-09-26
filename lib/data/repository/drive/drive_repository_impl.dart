import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/drive.dart';
import '../../../entity/position.dart';
import '../../../ui/service/date_service.dart';
import '../../local_db/dto/drive_position_sqlite_dto.dart';
import '../../local_db/dto/drive_sqlite_dto.dart';
import '../../local_db/service/drive_position_sqlite_service.dart';
import '../../local_db/service/drive_sqlite_service.dart';
import '../../mapper/drive_mapper.dart';
import '../repository.dart';
import 'drive_repository.dart';

@LazySingleton(as: DriveRepository)
class DriveRepositoryImpl extends Repository<Drive> implements DriveRepository {
  final DriveSqliteService _driveSqliteService;
  final DrivePositionSqliteService _drivePositionSqliteService;
  final DriveMapper _driveMapper;
  final DateService _dateService;

  DriveRepositoryImpl(
    this._driveSqliteService,
    this._drivePositionSqliteService,
    this._driveMapper,
    this._dateService,
  );

  @override
  Stream<Drive?> getDriveById(int id) async* {
    await for (final drives in repositoryState$) {
      Drive? matchingDrive = drives.firstWhereOrNull(
        (Drive? drive) => drive?.id == id,
      );
      matchingDrive ??= await _fetchDriveById(id);
      yield matchingDrive;
    }
  }

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
    required String title,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required List<Position> positions,
  }) async {
    final addedDriveDto = await _driveSqliteService.insert(
      title: title,
      startDateTime: startDateTime,
      distanceInKm: distanceInKm,
      duration: duration,
    );
    if (addedDriveDto == null) return;
    final List<DrivePositionSqliteDto> addedPositionDtos = [];
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final addedPosDto = await _drivePositionSqliteService.insert(
        driveId: addedDriveDto.id,
        order: i + 1,
        latitude: pos.coordinates.latitude,
        longitude: pos.coordinates.longitude,
        elevation: pos.elevation,
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

  @override
  Future<void> deleteDriveById(int id) async {
    await _drivePositionSqliteService.deleteByDriveId(driveId: id);
    await _driveSqliteService.deleteById(id: id);
    removeEntity(id);
  }

  Future<Drive?> _fetchDriveById(int id) async {
    final DriveSqliteDto? driveDto =
        await _driveSqliteService.queryById(id: id);
    if (driveDto == null) return null;
    final Drive drive = await _mapDriveSqliteDtoToDrive(driveDto);
    addEntity(drive);
    return drive;
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
    final List<DrivePositionSqliteDto> positionDtos =
        await _drivePositionSqliteService.queryByDriveId(
      driveId: dto.id,
    );
    return _driveMapper.mapFromDto(
      driveDto: dto,
      positionDtos: positionDtos,
    );
  }
}
