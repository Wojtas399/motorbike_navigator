import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/place/place_suggestion_repository_method_providers.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/map/provider/place_suggestions_provider.dart';

import '../../mock/listener.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      const AsyncData<List<PlaceSuggestion>>([]),
    );
  });

  test(
    'build, '
    'should return empty array',
    () async {
      final container = ProviderContainer();

      final List<PlaceSuggestion> suggestions = await container.read(
        placeSuggestionsProvider.future,
      );

      expect(suggestions, []);
    },
  );

  test(
    'search, '
    'should call searchPlacesProvider with limit set to 10 and should assign '
    'its result to state',
    () async {
      const String query = 'query';
      const int limit = 10;
      const List<PlaceSuggestion> suggestions = [
        PlaceSuggestion(id: 'id1', name: 'name 1', fullAddress: 'address 1'),
        PlaceSuggestion(id: 'id2', name: 'name 2', fullAddress: 'address 2'),
        PlaceSuggestion(id: 'id3', name: 'name 3', fullAddress: 'address 3'),
      ];
      final container = ProviderContainer(
        overrides: [
          searchPlacesProvider(query: query, limit: limit).overrideWith(
            (_) => Future.value(suggestions),
          ),
        ],
      );
      final listener = Listener<AsyncValue<List<PlaceSuggestion>>>();
      container.listen(
        placeSuggestionsProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(placeSuggestionsProvider.future);
      await container.read(placeSuggestionsProvider.notifier).search(query);

      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<List<PlaceSuggestion>>(),
            ),
        () => listener(
              const AsyncLoading<List<PlaceSuggestion>>(),
              any(that: isA<AsyncData>()),
            ),
        () => listener(
              any(that: isA<AsyncData>()),
              any(that: isA<AsyncLoading>()),
            ),
        () => listener(
              any(that: isA<AsyncLoading>()),
              const AsyncData<List<PlaceSuggestion>>(suggestions),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
