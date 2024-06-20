import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../env.dart';

@singleton
class MapboxNavigationApi {
  final Uri _baseUri = Uri.parse(
    'https://api.mapbox.com/directions/v5/mapbox/driving',
  );

  Future<Map<String, dynamic>> fetchNavigation({
    required ({double lat, double long}) startLocation,
    required ({double lat, double long}) destinationLocation,
  }) async {
    final uri = _createUri(startLocation, destinationLocation);
    final response = await http.get(uri);
    return json.decode(response.body);
  }

  Uri _createUri(
    ({double lat, double long}) startLocation,
    ({double lat, double long}) destinationLocation,
  ) {
    final String startPlaceCoordStr =
        '${startLocation.long},${startLocation.lat}';
    final String destinationCoordStr =
        '${destinationLocation.long},${destinationLocation.lat}';
    return Uri(
      scheme: _baseUri.scheme,
      host: _baseUri.host,
      path: '${_baseUri.path}/$startPlaceCoordStr;$destinationCoordStr',
      queryParameters: {
        'access_token': Env.mapboxAccessToken,
        'geometries': 'geojson',
      },
    );
  }
}
