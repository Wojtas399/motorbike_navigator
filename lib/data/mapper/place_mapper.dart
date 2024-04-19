import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import '../dto/place_dto.dart';

Place mapPlaceFromDto(PlaceDto dto) => Place(
      id: dto.properties.id,
      name: dto.properties.name,
      fullAddress: dto.properties.fullAddress,
      coordinates: Coordinates(
        dto.geometry.coordinates.lat,
        dto.geometry.coordinates.long,
      ),
    );
