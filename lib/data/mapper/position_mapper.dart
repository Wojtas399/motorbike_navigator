import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/position.dart';
import '../sqlite/dto/position_sqlite_dto.dart';

@injectable
class PositionMapper {
  const PositionMapper();

  Position mapFromDto(PositionSqliteDto dto) => Position(
        coordinates: Coordinates(
          dto.latitude,
          dto.longitude,
        ),
        altitude: dto.altitude,
        speedInKmPerH: dto.speedInKmPerH,
      );
}
