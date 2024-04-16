import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api/mapbox_search_api.dart';

class MockMapboxSearchApi extends Mock implements MapboxSearchApi {
  void mockFetchPlaceSuggestions({
    required Map<String, dynamic> result,
  }) {
    when(
      () => fetchPlaceSuggestions(
        query: any(named: 'query'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => Future.value(result));
  }

  void mockFetchPlaceById({
    required Map<String, dynamic> result,
  }) {
    when(
      () => fetchPlaceById(any()),
    ).thenAnswer((invocation) => Future.value(result));
  }
}
