import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../dto/place_suggestion_dto.dart';
import 'mapbox_search_api.dart';

part 'place_suggestion_api_service.g.dart';

class PlaceSuggestionApiService {
  final MapboxSearchApi _mapboxSearchApi;

  PlaceSuggestionApiService(Ref ref)
      : _mapboxSearchApi = ref.read(mapboxSearchApiProvider);

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

@riverpod
PlaceSuggestionApiService placeSuggestionApiService(
  PlaceSuggestionApiServiceRef ref,
) =>
    PlaceSuggestionApiService(ref);
