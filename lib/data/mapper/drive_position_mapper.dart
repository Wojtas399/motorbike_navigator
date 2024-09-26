import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/drive.dart';
import '../local_db/dto/drive_position_sqlite_dto.dart';

@injectable
class DrivePositionMapper {
  const DrivePositionMapper();

  DrivePosition mapFromDto(DrivePositionSqliteDto dto) => DrivePosition(
        order: dto.order,
        coordinates: Coordinates(
          dto.latitude,
          dto.longitude,
        ),
        elevation: dto.elevation,
        speedInKmPerH: dto.speedInKmPerH,
      );
}
