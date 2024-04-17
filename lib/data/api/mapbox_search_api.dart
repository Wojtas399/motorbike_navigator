import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../env.dart';

@singleton
class MapboxSearchApi {
  final String _sessionToken = const Uuid().v4();
  final Uri _baseUri = Uri.parse('https://api.mapbox.com/search/searchbox/v1/');

  Future<Map<String, dynamic>> fetchPlaceSuggestions({
    required String query,
    required int limit,
  }) async {
    final uri = _createUri(query, isSuggestions: true, limit: limit);
    final response = await http.get(uri);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchPlaceById(String id) async {
    final uri = _createUri(id);
    final response = await http.get(uri);
    return json.decode(response.body);
  }

  Uri _createUri(
    String queryOrId, {
    bool isSuggestions = false,
    int? limit,
  }) {
    return Uri(
      scheme: _baseUri.scheme,
      host: _baseUri.host,
      path: _baseUri.path + (isSuggestions ? 'suggest' : 'retrieve/$queryOrId'),
      queryParameters: {
        'access_token': Env.mapboxAccessToken,
        'session_token': _sessionToken,
        if (isSuggestions) ...{
          'q': queryOrId,
          if (limit != null) 'limit': limit.toString(),
        }
      },
    );
  }
}
