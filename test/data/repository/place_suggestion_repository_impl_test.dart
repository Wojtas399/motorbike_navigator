import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';
import 'package:motorbike_navigator/data/repository/place_suggestion/place_suggestion_repository_impl.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';

import '../../mock/data/api_service/mock_place_suggestion_api_service.dart';

void main() {
  final placeSuggestionApiService = MockPlaceSuggestionApiService();

  test(
    'searchPlaces, '
    'should call method from MapboxApiService to search places by query and '
    'should return its result',
    () async {
      const String query = 'query';
      const int limit = 15;
      final List<PlaceSuggestionDto> placeSuggestionDtos = [
        const PlaceSuggestionDto(
          id: 'ps1',
          name: 'place_suggestion 1',
          fullAddress: 'address 1',
        ),
        const PlaceSuggestionDto(
          id: 'ps2',
          name: 'place_suggestion 2',
          fullAddress: 'address 2',
        ),
        const PlaceSuggestionDto(
          id: 'ps3',
          name: 'place_suggestion 3',
        ),
      ];
      final List<PlaceSuggestion> expectedPlaceSuggestions = [
        const PlaceSuggestion(
          id: 'ps1',
          name: 'place_suggestion 1',
          fullAddress: 'address 1',
        ),
        const PlaceSuggestion(
          id: 'ps2',
          name: 'place_suggestion 2',
          fullAddress: 'address 2',
        ),
        const PlaceSuggestion(
          id: 'ps3',
          name: 'place_suggestion 3',
        ),
      ];
      placeSuggestionApiService.mockSearchPlaces(result: placeSuggestionDtos);
      final repositoryImpl = PlaceSuggestionRepositoryImpl(
        placeSuggestionApiService,
      );

      final List<PlaceSuggestion> foundPlaces =
          await repositoryImpl.searchPlaces(query: query, limit: limit);

      expect(foundPlaces, expectedPlaceSuggestions);
    },
  );
}
