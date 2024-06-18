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

  Future<void> searchPlaceSuggestions(String query) async {
    emit(state.copyWith(
      status: SearchFormStateStatus.loading,
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

  void resetPlaceSuggestions() {
    emit(state.copyWith(
      placeSuggestions: null,
    ));
  }
}
