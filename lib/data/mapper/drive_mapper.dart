import 'package:injectable/injectable.dart';

import '../../entity/drive.dart';
import '../local_db/dto/drive_sqlite_dto.dart';

@injectable
class DriveMapper {
  const DriveMapper();

  Drive mapFromDto({
    required DriveSqliteDto driveDto,
    required List<DrivePosition> positions,
  }) =>
      Drive(
        id: driveDto.id,
        title: driveDto.title,
        startDateTime: driveDto.startDateTime,
        distanceInKm: driveDto.distanceInKm,
        duration: driveDto.duration,
        positions: positions,
      );
}
