import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/place_suggestion/place_suggestion_repository.dart';
import '../../../../entity/place_suggestion.dart';
import 'search_form_state.dart';

@injectable
class SearchFormCubit extends Cubit<SearchFormState> {
  final PlaceSuggestionRepository _placeSuggestionRepository;

  SearchFormCubit(
    this._placeSuggestionRepository,
  ) : super(const SearchFormState());

  Future<void> initialize(String query) async {
    await _loadPlaceSuggestions(query);
  }

  void onSearchQueryChanged(String query) {
    emit(state.copyWith(
      searchQuery: query,
    ));
  }

  Future<void> searchPlaceSuggestions() async {
    await _loadPlaceSuggestions(state.searchQuery);
  }

  void resetPlaceSuggestions() {
    emit(state.copyWith(
      placeSuggestions: null,
    ));
  }

  Future<void> _loadPlaceSuggestions(String query) async {
    if (query.isEmpty) return;
    emit(state.copyWith(
      status: SearchFormStateStatus.loading,
      searchQuery: query,
    ));
    final List<PlaceSuggestion> suggestions =
        await _placeSuggestionRepository.searchPlaces(
      query: query,
      limit: 10,
    );
    emit(state.copyWith(
      status: SearchFormStateStatus.completed,
      placeSuggestions: suggestions,
    ));
  }
}
