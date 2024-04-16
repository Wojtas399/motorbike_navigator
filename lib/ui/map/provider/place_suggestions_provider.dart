import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repository/place_suggestion/place_suggestion_repository_method_providers.dart';
import '../../../entity/place_suggestion.dart';

part 'place_suggestions_provider.g.dart';

@riverpod
class PlaceSuggestions extends _$PlaceSuggestions {
  @override
  Future<List<PlaceSuggestion>> build() async => [];

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.watch(
        searchPlacesProvider(
          query: query,
          limit: 10,
        ).future,
      ),
    );
  }
}
