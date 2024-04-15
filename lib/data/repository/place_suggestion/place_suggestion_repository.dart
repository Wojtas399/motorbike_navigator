import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../entity/place_suggestion.dart';
import 'place_suggestion_repository_impl.dart';

part 'place_suggestion_repository.g.dart';

abstract interface class PlaceSuggestionRepository {
  Future<List<PlaceSuggestion>> searchPlaces({
    required String query,
    required int limit,
  });
}

@riverpod
PlaceSuggestionRepository placeSuggestionRepository(
  PlaceSuggestionRepositoryRef ref,
) =>
    PlaceSuggestionRepositoryImpl(ref);
