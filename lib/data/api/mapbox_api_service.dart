import 'package:mapbox_search/mapbox_search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../dto/place_suggestion_dto.dart';

part 'mapbox_api_service.g.dart';

class MapboxApiService {
  Future<List<PlaceSuggestionDto>> searchPlaces({
    required String query,
    required int limit,
  }) async {
    SearchBoxAPI search = SearchBoxAPI(limit: limit);
    ApiResponse<SuggestionResponse> searchPlace =
        await search.getSuggestions(query);
    return [
      ...?searchPlace.success?.suggestions
          .map(PlaceSuggestionDto.fromMapboxSuggestion),
    ];
  }
}

@riverpod
MapboxApiService mapboxApiService(MapboxApiServiceRef ref) =>
    MapboxApiService();
