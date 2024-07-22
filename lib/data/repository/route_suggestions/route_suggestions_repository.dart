import '../../../entity/coordinates.dart';
import '../../../entity/route_suggestions.dart';

abstract interface class RouteSuggestionsRepository {
  Future<RouteSuggestions?> loadRouteSuggestionsByStartAndEndLocations({
    required Coordinates startLocation,
    required Coordinates endLocation,
  });
}
