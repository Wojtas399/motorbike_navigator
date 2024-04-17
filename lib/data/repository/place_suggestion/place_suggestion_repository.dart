import '../../../entity/place_suggestion.dart';

abstract interface class PlaceSuggestionRepository {
  Future<List<PlaceSuggestion>> searchPlaces({
    required String query,
    required int limit,
  });
}
