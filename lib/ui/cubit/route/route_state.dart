import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/navigation.dart';
import '../../../../entity/place_suggestion.dart';

part 'route_state.freezed.dart';

enum RouteStateStatus { infill, searching }

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    @Default(RouteStateStatus.infill) RouteStateStatus status,
    PlaceSuggestion? startPlaceSuggestion,
    PlaceSuggestion? destinationSuggestion,
    Route? route,
  }) = _RouteState;
}
