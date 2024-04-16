import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';

void main() {
  test(
    'fromMapboxFeature, '
    'should map Feature object from mapbox plugin to PlaceDto object',
    () {
      const String id = 'p1';
      const String name = 'place';
      const double latitude = 50.5;
      const double longitude = 47.6;
      final Feature feature = Feature(
        type: '',
        geometry: Geometry(
          coordinates: (lat: latitude, long: longitude),
          type: '',
        ),
        properties: Properties(
          wikidata: name,
        ),
      );
      const PlaceDto expectedPlaceDto = PlaceDto(
        id: id,
        name: name,
        coordinates: CoordinatesDto(latitude, longitude),
      );

      final PlaceDto placeDto = PlaceDto.fromMapboxFeature(
        id: id,
        feature: feature,
      );

      expect(placeDto, expectedPlaceDto);
    },
  );
}
