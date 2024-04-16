import '../../entity/place.dart';
import '../dto/place_dto.dart';
import 'coordinates_mapper.dart';

Place mapPlaceFromDto(PlaceDto dto) => Place(
      id: dto.id,
      name: dto.name,
      coordinates: mapCoordinatesFromDto(dto.coordinates),
    );
