import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/route_suggestions/route_suggestions_repository.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/route_suggestions.dart';

class MockRouteSuggestionsRepository extends Mock
    implements RouteSuggestionsRepository {
  MockRouteSuggestionsRepository() {
    registerFallbackValue(const Coordinates(50.1, 18.1));
  }

  void mockLoadRouteSuggestionsByStartAndEndLocations({
    RouteSuggestions? expectedRouteSuggestions,
  }) {
    when(
      () => loadRouteSuggestionsByStartAndEndLocations(
        startLocation: any(named: 'startLocation'),
        endLocation: any(named: 'endLocation'),
      ),
    ).thenAnswer((_) => Future.value(expectedRouteSuggestions));
  }
}
