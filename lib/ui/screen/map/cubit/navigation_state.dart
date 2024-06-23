import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/place_suggestion.dart';

part 'navigation_state.freezed.dart';

@freezed
class NavigationState with _$NavigationState {
  const factory NavigationState({
    PlaceSuggestion? startPlaceSuggestion,
    PlaceSuggestion? destinationSuggestion,
    List<Coordinates>? wayPoints,
  }) = _NavigationState;
}
