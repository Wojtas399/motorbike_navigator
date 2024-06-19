import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../env.dart';

@singleton
class MapboxNavigationApi {
  final Uri _baseUri = Uri.parse(
    'https://api.mapbox.com/directions/v5/mapbox/driving',
  );

  Future<Map<String, dynamic>> fetchRoute({
    required ({double lat, double long}) startPlaceCoordinates,
    required ({double lat, double long}) destinationCoordinates,
  }) async {
    final uri = _createUri(
      startPlaceCoordinates: startPlaceCoordinates,
      destinationCoordinates: destinationCoordinates,
    );
    final response = await http.get(uri);
    return json.decode(response.body);
  }

  Uri _createUri({
    required ({double lat, double long}) startPlaceCoordinates,
    required ({double lat, double long}) destinationCoordinates,
  }) {
    final String startPlaceCoordStr =
        '${startPlaceCoordinates.long},${startPlaceCoordinates.lat}';
    final String destinationCoordStr =
        '${destinationCoordinates.long},${destinationCoordinates.lat}';
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
