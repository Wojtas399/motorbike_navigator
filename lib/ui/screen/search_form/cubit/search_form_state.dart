import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/place_suggestion.dart';

part 'search_form_state.freezed.dart';

enum SearchFormStateStatus { loading, completed }

extension SearchFormStateStatusExtension on SearchFormStateStatus {
  bool get isLoading => this == SearchFormStateStatus.loading;

  bool get isCompleted => this == SearchFormStateStatus.completed;
}

@freezed
class SearchFormState with _$SearchFormState {
  const factory SearchFormState({
    @Default(SearchFormStateStatus.completed) SearchFormStateStatus status,
    @Default('') String searchQuery,
    List<PlaceSuggestion>? placeSuggestions,
  }) = _SearchFormState;
}
