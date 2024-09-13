import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/position.dart';
import '../local_db/dto/position_sqlite_dto.dart';

@injectable
class PositionMapper {
  const PositionMapper();

  Position mapFromDto(PositionSqliteDto dto) => Position(
        coordinates: Coordinates(
          dto.latitude,
          dto.longitude,
        ),
        elevation: dto.elevation,
        speedInKmPerH: dto.speedInKmPerH,
      );
}
