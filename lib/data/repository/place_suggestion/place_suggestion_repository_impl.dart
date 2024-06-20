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
    // return const [
    //   PlaceSuggestion(
    //     id: 'p1',
    //     name: 'place 1',
    //     fullAddress: 'full address for place 1',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p2',
    //     name: 'place 2',
    //     fullAddress: 'full address for place 2',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p3',
    //     name: 'place 3',
    //     fullAddress: 'full address for place 3',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p4',
    //     name: 'place 4',
    //     fullAddress: 'full address for place 4',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p5',
    //     name: 'place 5',
    //     fullAddress: 'full address for place 5',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p6',
    //     name: 'place 6',
    //     fullAddress: 'full address for place 6',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p7',
    //     name: 'place 7',
    //     fullAddress: 'full address for place 7',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p8',
    //     name: 'place 8',
    //     fullAddress: 'full address for place 8',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p9',
    //     name: 'place 9',
    //     fullAddress: 'full address for place 9',
    //   ),
    //   PlaceSuggestion(
    //     id: 'p10',
    //     name: 'place 10',
    //     fullAddress: 'full address for place 10',
    //   ),
    // ];
    final List<PlaceSuggestionDto> placeDtos =
        await _placeSuggestionApiService.searchPlaces(
      query: query,
      limit: limit,
    );
    return placeDtos.map(mapPlaceSuggestionFromDto).toList();
  }
}
