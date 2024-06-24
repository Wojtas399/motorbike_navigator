import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/navigation.dart';
import '../../../../entity/place_suggestion.dart';

part 'route_form_state.freezed.dart';

@freezed
class RouteFormState with _$RouteFormState {
  const factory RouteFormState({
    PlaceSuggestion? startPlaceSuggestion,
    PlaceSuggestion? destinationSuggestion,
    Route? route,
  }) = _RouteFormState;
}
