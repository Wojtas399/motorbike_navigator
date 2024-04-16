import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import '../dto/place_dto.dart';

Place mapPlaceFromDto(PlaceDto dto) => Place(
      id: dto.properties.mapboxId,
      name: dto.properties.name,
      coordinates: Coordinates(
        dto.geometry.coordinates.lat,
        dto.geometry.coordinates.long,
      ),
    );
