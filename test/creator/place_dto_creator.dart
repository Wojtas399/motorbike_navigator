import 'package:motorbike_navigator/data/dto/place_dto.dart';
import 'package:motorbike_navigator/data/dto/place_geometry_dto.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';

class PlaceDtoCreator {
  PlaceDto create({
    String id = '',
    String name = '',
    String fullAddress = '',
    double latitude = 0,
    double longitude = 0,
  }) =>
      PlaceDto(
        properties: PlacePropertiesDto(
          id: id,
          name: name,
          fullAddress: fullAddress,
        ),
        geometry: PlaceGeometryDto(
          coordinates: (lat: latitude, long: longitude),
        ),
      );
}
