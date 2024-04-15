import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../entity/place_suggestion.dart';
import 'place_suggestion_repository.dart';

part 'place_suggestion_repository_method_providers.g.dart';

@riverpod
Future<List<PlaceSuggestion>> searchPlaces(
  SearchPlacesRef ref, {
  required String query,
  required int limit,
}) async =>
    ref.watch(placeSuggestionRepositoryProvider).searchPlaces(
          query: query,
          limit: limit,
        );
