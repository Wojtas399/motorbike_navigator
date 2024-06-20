import 'package:injectable/injectable.dart';

import '../api/mapbox_search_api.dart';
import '../dto/place_suggestion_dto.dart';

@injectable
class PlaceSuggestionApiService {
  final MapboxSearchApi _mapboxSearchApi;

  PlaceSuggestionApiService(this._mapboxSearchApi);

  Future<List<PlaceSuggestionDto>> searchPlaces({
    required String query,
    required int limit,
  }) async {
    final json = await _mapboxSearchApi.fetchPlaceSuggestions(
      query: query,
      limit: limit,
    );
    final suggestions = json['suggestions'] as List;
    return suggestions
        .map((json) => PlaceSuggestionDto.fromJson(json))
        .toList();
  }
}
