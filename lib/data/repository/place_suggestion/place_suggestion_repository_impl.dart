import 'package:injectable/injectable.dart';

import '../../../entity/place_suggestion.dart';
import '../../api_service/place_suggestion_api_service.dart';
import '../../dto/place_suggestion_dto.dart';
import '../../mapper/place_suggestion_mapper.dart';
import 'place_suggestion_repository.dart';

@LazySingleton(as: PlaceSuggestionRepository)
class PlaceSuggestionRepositoryImpl implements PlaceSuggestionRepository {
  final PlaceSuggestionApiService _placeSuggestionApiService;

  PlaceSuggestionRepositoryImpl(this._placeSuggestionApiService);

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
