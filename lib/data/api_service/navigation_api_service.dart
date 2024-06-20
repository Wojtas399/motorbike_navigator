import 'package:injectable/injectable.dart';

import '../api/mapbox_navigation_api.dart';
import '../dto/navigation_dto.dart';

@injectable
class NavigationApiService {
  final MapboxNavigationApi _mapboxNavigationApi;

  NavigationApiService(this._mapboxNavigationApi);

  Future<NavigationDto> fetchNavigation({
    required ({double lat, double long}) startLocation,
    required ({double lat, double long}) destinationLocation,
  }) async {
    final json = await _mapboxNavigationApi.fetchNavigation(
      startLocation: startLocation,
      destinationLocation: destinationLocation,
    );
    return NavigationDto.fromJson(json);
  }
}
