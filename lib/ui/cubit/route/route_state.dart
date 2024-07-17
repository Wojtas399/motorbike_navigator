import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/navigation.dart';
import '../../../../entity/place_suggestion.dart';

part 'route_state.freezed.dart';

enum RouteStateStatus {
  initial,
  infill,
  searching,
  routeFound,
  routeNotFound,
}

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    @Default(RouteStateStatus.initial) RouteStateStatus status,
    PlaceSuggestion? startPlaceSuggestion,
    PlaceSuggestion? destinationSuggestion,
    Route? route,
  }) = _RouteState;
}
