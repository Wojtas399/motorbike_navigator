import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/repository/place_suggestion/place_suggestion_repository.dart';
import 'package:motorbike_navigator/data/repository/place_suggestion/place_suggestion_repository_method_providers.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';

import '../../../mock/data/repository/mock_place_suggestion_repository.dart';

void main() {
  test(
    'searchPlaces, '
    'should return place suggestions got directly from PlaceSuggestionRepository',
    () async {
      const String query = 'p';
      const int limit = 10;
      const List<PlaceSuggestion> expectedPlaceSuggestions = [
        PlaceSuggestion(
            id: 'ps1', name: 'place_suggestion 1', fullAddress: 'address 1'),
        PlaceSuggestion(
            id: 'ps2', name: 'place_suggestion 2', fullAddress: 'address 2'),
        PlaceSuggestion(
            id: 'ps3', name: 'place_suggestion 3', fullAddress: 'address 3'),
      ];
      final placeSuggestionRepository = MockPlaceSuggestionRepository();
      placeSuggestionRepository.mockSearchPlaces(
        result: expectedPlaceSuggestions,
      );
      final container = ProviderContainer(
        overrides: [
          placeSuggestionRepositoryProvider.overrideWithValue(
            placeSuggestionRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      final List<PlaceSuggestion> placeSuggestions = await container.read(
        searchPlacesProvider(
          query: query,
          limit: limit,
        ).future,
      );

      expect(placeSuggestions, expectedPlaceSuggestions);
    },
  );
}
