import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/api/place_suggestion_api_service.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';

import '../../mock/data/api/mock_mapbox_search_api.dart';

void main() {
  final mapboxSearchApi = MockMapboxSearchApi();

  test(
    'searchPlaces, '
    'should call method from MapboxSearchApi to fetch place suggestions and '
    'should return list of PlaceSuggestionDto objects',
    () async {
      const String query = 'query';
      const int limit = 5;
      final Map<String, dynamic> apiResponseJson =
          _createListOfPlaceSuggestionsResponseJson(
        suggestions: [
          _createPlaceSuggestionResponseJson(
            mapboxId: 'p1',
            name: 'place 1',
            fullAddress: 'address 1',
          ),
          _createPlaceSuggestionResponseJson(
            mapboxId: 'p2',
            name: 'place 2',
            fullAddress: 'address 2',
          ),
          _createPlaceSuggestionResponseJson(
            mapboxId: 'p3',
            name: 'place 3',
            fullAddress: 'address 3',
          ),
        ],
      );
      const List<PlaceSuggestionDto> expectedPlaceSuggestionDtos = [
        PlaceSuggestionDto(
          id: 'p1',
          name: 'place 1',
          fullAddress: 'address 1',
        ),
        PlaceSuggestionDto(
          id: 'p2',
          name: 'place 2',
          fullAddress: 'address 2',
        ),
        PlaceSuggestionDto(
          id: 'p3',
          name: 'place 3',
          fullAddress: 'address 3',
        ),
      ];
      mapboxSearchApi.mockFetchPlaceSuggestions(result: apiResponseJson);
      final apiService = PlaceSuggestionApiService(mapboxSearchApi);

      final List<PlaceSuggestionDto> placeSuggestionDtos =
          await apiService.searchPlaces(query: query, limit: limit);

      expect(placeSuggestionDtos, expectedPlaceSuggestionDtos);
    },
  );
}

Map<String, dynamic> _createListOfPlaceSuggestionsResponseJson({
  required List<Map<String, dynamic>> suggestions,
}) =>
    {
      'suggestions': suggestions,
    };

Map<String, dynamic> _createPlaceSuggestionResponseJson({
  required String mapboxId,
  required String name,
  required String fullAddress,
}) =>
    {
      'mapbox_id': mapboxId,
      'name': name,
      'full_address': fullAddress,
    };
