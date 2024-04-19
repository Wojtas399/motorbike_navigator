import 'package:injectable/injectable.dart';

import '../dto/place_dto.dart';
import 'mapbox_search_api.dart';

@injectable
class PlaceApiService {
  final MapboxSearchApi _mapboxSearchApi;

  PlaceApiService(this._mapboxSearchApi);

  Future<PlaceDto?> fetchPlaceById(String id) async {
    final json = await _mapboxSearchApi.fetchPlaceById(id);
    final List places = json['features'] as List;
    print(places.first);
    return places.isNotEmpty ? PlaceDto.fromJson(places.first) : null;
  }
}
