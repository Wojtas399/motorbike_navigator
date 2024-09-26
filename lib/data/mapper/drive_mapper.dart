import 'package:injectable/injectable.dart';

import '../../entity/drive.dart';
import '../local_db/dto/drive_position_sqlite_dto.dart';
import '../local_db/dto/drive_sqlite_dto.dart';
import 'drive_position_mapper.dart';

@injectable
class DriveMapper {
  final DrivePositionMapper _drivePositionMapper;

  const DriveMapper(this._drivePositionMapper);

  Drive mapFromDto({
    required DriveSqliteDto driveDto,
    required List<DrivePositionSqliteDto> positionDtos,
  }) {
    return Drive(
      id: driveDto.id,
      title: driveDto.title,
      startDateTime: driveDto.startDateTime,
      distanceInKm: driveDto.distanceInKm,
      duration: driveDto.duration,
      positions: positionDtos.map(_drivePositionMapper.mapFromDto).toList(),
    );
  }
}
