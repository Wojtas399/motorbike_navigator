import 'package:injectable/injectable.dart';

import '../api/mapbox_search_api.dart';
import '../dto/place_dto.dart';

@injectable
class PlaceApiService {
  final MapboxSearchApi _mapboxSearchApi;

  PlaceApiService(this._mapboxSearchApi);

  Future<PlaceDto?> fetchPlaceById(String id) async {
    final json = await _mapboxSearchApi.fetchPlaceById(id);
    final List places = json['features'] as List;
    return places.isNotEmpty ? PlaceDto.fromJson(places.first) : null;
  }
}
