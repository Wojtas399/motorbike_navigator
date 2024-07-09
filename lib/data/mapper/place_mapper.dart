import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import '../dto/place_dto.dart';
import 'mapper.dart';

@injectable
class PlaceMapper extends Mapper<Place, PlaceDto> {
  @override
  Place mapFromDto(PlaceDto dto) => Place(
        id: dto.properties.id,
        name: dto.properties.name,
        fullAddress: dto.properties.fullAddress,
        coordinates: Coordinates(
          dto.geometry.coordinates.lat,
          dto.geometry.coordinates.long,
        ),
      );
}
