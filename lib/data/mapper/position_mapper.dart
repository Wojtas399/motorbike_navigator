import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/position.dart';
import '../dto/coordinates_dto.dart';
import '../dto/position_dto.dart';
import 'mapper.dart';

@injectable
class PositionMapper extends Mapper<Position, PositionDto> {
  const PositionMapper();

  @override
  Position mapFromDto(PositionDto dto) => Position(
        coordinates: Coordinates(
          dto.coordinates.latitude,
          dto.coordinates.longitude,
        ),
        altitude: dto.altitude,
        speedInKmPerH: dto.speedInKmPerH,
      );

  @override
  PositionDto mapToDto(Position object) => PositionDto(
        coordinates: CoordinatesDto(
          latitude: object.coordinates.latitude,
          longitude: object.coordinates.longitude,
        ),
        altitude: object.altitude,
        speedInKmPerH: object.speedInKmPerH,
      );
}
