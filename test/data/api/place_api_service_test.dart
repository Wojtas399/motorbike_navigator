import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/api/place_api_service.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';
import 'package:motorbike_navigator/data/dto/place_geometry_dto.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';

import '../../mock/data/api/mock_mapbox_search_api.dart';

void main() {
  final mapboxSearchApi = MockMapboxSearchApi();

  test(
    'fetchPlaceById, '
    'should call method from MapboxSearchApi to fetch place by id and should '
    'return PlaceDto object',
    () async {
      const String placeId = 'p1';
      const String name = 'place 1';
      const double latitude = 50.23;
      const double longitude = 44.3;
      final Map<String, dynamic> apiResponseJson = _createPlaceResponseJson(
        features: [
          _createPlaceDetailsResponseJson(
            mapboxId: placeId,
            name: name,
            coordinates: (lat: latitude, long: longitude),
          ),
        ],
      );
      const PlaceDto expectedPlaceDto = PlaceDto(
        properties: PlacePropertiesDto(
          id: placeId,
          name: name,
        ),
        geometry: PlaceGeometryDto(
          coordinates: (lat: latitude, long: longitude),
        ),
      );
      mapboxSearchApi.mockFetchPlaceById(result: apiResponseJson);
      final apiService = PlaceApiService(mapboxSearchApi);

      final PlaceDto? placeDto = await apiService.fetchPlaceById(placeId);

      expect(placeDto, expectedPlaceDto);
    },
  );
}

Map<String, dynamic> _createPlaceResponseJson({
  required List<Map<String, dynamic>> features,
}) =>
    {
      'features': features,
    };

Map<String, dynamic> _createPlaceDetailsResponseJson({
  required String mapboxId,
  required String name,
  required ({double lat, double long}) coordinates,
}) =>
    {
      'properties': {
        'mapbox_id': mapboxId,
        'name': name,
      },
      'geometry': {
        'coordinates': [coordinates.lat, coordinates.long],
      },
    };
