import 'package:mapbox_search/mapbox_search.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../dto/place_dto.dart';

part 'place_api_service.g.dart';

class PlaceApiService {
  Future<PlaceDto?> fetchPlaceById(String id) async {
    SearchBoxAPI search = SearchBoxAPI();
    final ApiResponse<RetrieveResonse> searchPlace = await search.getPlace(id);
    final features = searchPlace.success?.features;
    return features?.isNotEmpty == true
        ? PlaceDto.fromMapboxFeature(
            id: id,
            feature: features!.first,
          )
        : null;
  }
}

@riverpod
PlaceApiService placeApiService(PlaceApiServiceRef ref) => PlaceApiService();
