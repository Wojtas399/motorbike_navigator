import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/place_suggestion.dart';

part 'search_form_state.freezed.dart';

enum SearchFormStateStatus { loading, completed }

@freezed
class SearchFormState with _$SearchFormState {
  const factory SearchFormState({
    @Default(SearchFormStateStatus.completed) SearchFormStateStatus status,
    List<PlaceSuggestion>? placeSuggestions,
  }) = _SearchFormState;
}
