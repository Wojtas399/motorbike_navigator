import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../entity/place_suggestion.dart';
import '../../api/place_suggestion_api_service.dart';
import '../../dto/place_suggestion_dto.dart';
import '../../mapper/place_suggestion_mapper.dart';
import 'place_suggestion_repository.dart';

class PlaceSuggestionRepositoryImpl implements PlaceSuggestionRepository {
  final PlaceSuggestionApiService _placeSuggestionApiService;

  PlaceSuggestionRepositoryImpl(Ref ref)
      : _placeSuggestionApiService = ref.read(
          placeSuggestionApiServiceProvider,
        );

  @override
  Future<List<PlaceSuggestion>> searchPlaces({
    required String query,
    required int limit,
  }) async {
    final List<PlaceSuggestionDto> placeDtos =
        await _placeSuggestionApiService.searchPlaces(
      query: query,
      limit: limit,
    );
    return placeDtos.map(mapPlaceSuggestionFromDto).toList();
  }
}
