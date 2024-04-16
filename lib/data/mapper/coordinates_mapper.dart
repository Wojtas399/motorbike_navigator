import '../../entity/coordinates.dart';
import '../dto/coordinates_dto.dart';

Coordinates mapCoordinatesFromDto(CoordinatesDto dto) => Coordinates(
      dto.latitude,
      dto.longitude,
    );
