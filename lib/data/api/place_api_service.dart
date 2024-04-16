import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../dto/place_dto.dart';
import 'mapbox_search_api.dart';

part 'place_api_service.g.dart';

class PlaceApiService {
  final MapboxSearchApi _mapboxSearchApi;

  PlaceApiService(Ref ref)
      : _mapboxSearchApi = ref.read(mapboxSearchApiProvider);

  Future<PlaceDto?> fetchPlaceById(String id) async {
    final json = await _mapboxSearchApi.fetchPlaceById(id);
    final List places = json['features'] as List;
    return places.isNotEmpty ? PlaceDto.fromJson(places.first) : null;
  }
}

@riverpod
PlaceApiService placeApiService(PlaceApiServiceRef ref) => PlaceApiService(ref);
