import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/screen/search_form/cubit/search_form_cubit.dart';
import 'package:motorbike_navigator/ui/screen/search_form/cubit/search_form_state.dart';

import '../../../mock/data/repository/mock_place_suggestion_repository.dart';

void main() {
  final placeSuggestionRepository = MockPlaceSuggestionRepository();

  SearchFormCubit createCubit() => SearchFormCubit(placeSuggestionRepository);

  tearDown(() {
    reset(placeSuggestionRepository);
  });

  group(
    'initialize, ',
    () {
      const String query = 'query';
      const List<PlaceSuggestion> placeSuggestions = [
        PlaceSuggestion(id: 'p1', name: 'place 1'),
        PlaceSuggestion(id: 'p2', name: 'place 2'),
      ];
      SearchFormState? state;

      blocTest(
        'should do nothing if given param is null',
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(null),
        expect: () => [],
      );

      blocTest(
        'should do nothing if given param is empty string',
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(''),
        expect: () => [],
      );

      blocTest(
        'should get place suggestions from PlaceRepository limited to 10 suggestions',
        build: () => createCubit(),
        setUp: () => placeSuggestionRepository.mockSearchPlaces(
          result: placeSuggestions,
        ),
        act: (cubit) async => await cubit.initialize(query),
        expect: () => [
          state = const SearchFormState(
            status: SearchFormStateStatus.loading,
            searchQuery: query,
          ),
          state = state?.copyWith(
            status: SearchFormStateStatus.completed,
            placeSuggestions: placeSuggestions,
          ),
        ],
        verify: (_) => verify(
          () => placeSuggestionRepository.searchPlaces(
            query: query,
            limit: 10,
          ),
        ).called(1),
      );
    },
  );

  blocTest(
    'onSearchQueryChanged, '
    'should update searchQuery param in state',
    build: () => createCubit(),
    act: (cubit) => cubit.onSearchQueryChanged('query'),
    expect: () => [
      const SearchFormState(
        searchQuery: 'query',
      ),
    ],
  );

  group(
    'searchPlaceSuggestions, ',
    () {
      const String query = 'query';
      const List<PlaceSuggestion> placeSuggestions = [
        PlaceSuggestion(id: 'p1', name: 'place 1'),
        PlaceSuggestion(id: 'p2', name: 'place 2'),
      ];
      SearchFormState? state;

      blocTest(
        'should do nothing if searchQuery param is empty string',
        build: () => createCubit(),
        act: (cubit) => cubit.searchPlaceSuggestions(),
        expect: () => [],
      );

      blocTest(
        'should get place suggestions from PlaceRepository limited to 10 suggestions',
        build: () => createCubit(),
        setUp: () => placeSuggestionRepository.mockSearchPlaces(
          result: placeSuggestions,
        ),
        act: (cubit) {
          cubit.onSearchQueryChanged(query);
          cubit.searchPlaceSuggestions();
        },
        expect: () => [
          state = const SearchFormState(
            searchQuery: query,
          ),
          state = state?.copyWith(
            status: SearchFormStateStatus.loading,
          ),
          state = state?.copyWith(
            status: SearchFormStateStatus.completed,
            placeSuggestions: placeSuggestions,
          ),
        ],
        verify: (_) => verify(
          () => placeSuggestionRepository.searchPlaces(
            query: query,
            limit: 10,
          ),
        ).called(1),
      );
    },
  );

  group(
    'resetPlaceSuggestions, ',
    () {
      const String query = 'query';
      const List<PlaceSuggestion> placeSuggestions = [
        PlaceSuggestion(id: 'p1', name: 'place 1'),
        PlaceSuggestion(id: 'p2', name: 'place 2'),
      ];
      SearchFormState? state;

      blocTest(
        'should set placeSuggestions param as null and searchQuery param as empty '
        'string',
        setUp: () => placeSuggestionRepository.mockSearchPlaces(
          result: placeSuggestions,
        ),
        build: () => createCubit(),
        act: (cubit) async {
          cubit.onSearchQueryChanged(query);
          await cubit.searchPlaceSuggestions();
          cubit.resetPlaceSuggestions();
        },
        expect: () => [
          state = const SearchFormState(
            searchQuery: query,
          ),
          state = state?.copyWith(
            status: SearchFormStateStatus.loading,
          ),
          state = state?.copyWith(
            status: SearchFormStateStatus.completed,
            placeSuggestions: placeSuggestions,
          ),
          state = state?.copyWith(
            searchQuery: '',
            placeSuggestions: null,
          ),
        ],
      );
    },
  );
}
