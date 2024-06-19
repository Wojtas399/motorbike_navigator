import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/place_suggestion.dart';

part 'route_form_state.freezed.dart';

@freezed
class RouteFormState with _$RouteFormState {
  const factory RouteFormState({
    PlaceSuggestion? startPlace,
    PlaceSuggestion? destination,
  }) = _RouteFormState;
}
