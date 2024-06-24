import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/navigation.dart';
import '../../../../entity/place_suggestion.dart';

part 'route_state.freezed.dart';

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    PlaceSuggestion? startPlaceSuggestion,
    PlaceSuggestion? destinationSuggestion,
    Route? route,
  }) = _RouteState;
}
