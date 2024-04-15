import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/place_suggestion/place_suggestion_repository.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';

class MockPlaceSuggestionRepository extends Mock
    implements PlaceSuggestionRepository {
  void mockSearchPlaces({
    required List<PlaceSuggestion> result,
  }) {
    when(
      () => searchPlaces(
        query: any(named: 'query'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => Future.value(result));
  }
}
