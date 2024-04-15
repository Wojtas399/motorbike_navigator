import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorbike_navigator/data/api/mapbox_api_service.dart';
import 'package:motorbike_navigator/data/repository/place/place_suggestion_repository.dart';

import '../../../entity/place_suggestion.dart';
import '../../dto/place_suggestion_dto.dart';
import '../../mapper/place_suggestion_mapper.dart';

class PlaceSuggestionRepositoryImpl implements PlaceSuggestionRepository {
  final MapboxApiService _mapboxApiService;

  PlaceSuggestionRepositoryImpl(Ref ref)
      : _mapboxApiService = ref.read(mapboxApiServiceProvider);

  @override
  Future<List<PlaceSuggestion>> searchPlaces({
    required String query,
    required int limit,
  }) async {
    final List<PlaceSuggestionDto> placeDtos =
        await _mapboxApiService.searchPlaces(
      query: query,
      limit: limit,
    );
    return placeDtos.map(mapPlaceSuggestionFromDto).toList();
  }
}
