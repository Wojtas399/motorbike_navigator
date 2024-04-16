import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api/place_suggestion_api_service.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';

class MockPlaceSuggestionApiService extends Mock
    implements PlaceSuggestionApiService {
  void mockSearchPlaces({required List<PlaceSuggestionDto> result}) {
    when(
      () => searchPlaces(
        query: any(named: 'query'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => Future.value(result));
  }
}
