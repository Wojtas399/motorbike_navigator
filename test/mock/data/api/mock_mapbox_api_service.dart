import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api/mapbox_api_service.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';

class MockMapboxApiService extends Mock implements MapboxApiService {
  void mockSearchPlaces({required List<PlaceSuggestionDto> result}) {
    when(
      () => searchPlaces(
        query: any(named: 'query'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => Future.value(result));
  }
}
