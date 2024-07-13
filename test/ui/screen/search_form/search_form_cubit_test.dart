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

  blocTest(
    'initialize, '
    'query is empty string, '
    'should do nothing',
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(''),
    expect: () => [],
  );

  blocTest(
    'initialize, '
    'should get place suggestions from PlaceRepository limited to 10 suggestions',
    build: () => createCubit(),
    setUp: () => placeSuggestionRepository.mockSearchPlaces(
      result: [
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      ],
    ),
    act: (cubit) async => await cubit.initialize('query'),
    expect: () => [
      const SearchFormState(
        status: SearchFormStateStatus.loading,
        searchQuery: 'query',
      ),
      const SearchFormState(
        status: SearchFormStateStatus.completed,
        searchQuery: 'query',
        placeSuggestions: [
          PlaceSuggestion(id: 'p1', name: 'place 1'),
          PlaceSuggestion(id: 'p2', name: 'place 2'),
        ],
      ),
    ],
    verify: (_) => verify(
      () => placeSuggestionRepository.searchPlaces(
        query: 'query',
        limit: 10,
      ),
    ).called(1),
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

  blocTest(
    'searchPlaceSuggestions, '
    'searchQuery param is empty string, '
    'should do nothing',
    build: () => createCubit(),
    act: (cubit) => cubit.searchPlaceSuggestions(),
    expect: () => [],
  );

  blocTest(
    'searchPlaceSuggestions, '
    'should get place suggestions from PlaceRepository limited to 10 suggestions',
    build: () => createCubit(),
    setUp: () => placeSuggestionRepository.mockSearchPlaces(
      result: [
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      ],
    ),
    act: (cubit) {
      cubit.onSearchQueryChanged('query');
      cubit.searchPlaceSuggestions();
    },
    expect: () => [
      const SearchFormState(
        searchQuery: 'query',
      ),
      const SearchFormState(
        status: SearchFormStateStatus.loading,
        searchQuery: 'query',
      ),
      const SearchFormState(
        status: SearchFormStateStatus.completed,
        searchQuery: 'query',
        placeSuggestions: [
          PlaceSuggestion(id: 'p1', name: 'place 1'),
          PlaceSuggestion(id: 'p2', name: 'place 2'),
        ],
      ),
    ],
    verify: (_) => verify(
      () => placeSuggestionRepository.searchPlaces(
        query: 'query',
        limit: 10,
      ),
    ).called(1),
  );

  blocTest(
    'resetPlaceSuggestions, '
    'should set placeSuggestions param as null and searchQuery param as empty '
    'string',
    setUp: () => placeSuggestionRepository.mockSearchPlaces(
      result: const [
        PlaceSuggestion(id: 'p1', name: 'place 1'),
        PlaceSuggestion(id: 'p2', name: 'place 2'),
      ],
    ),
    build: () => createCubit(),
    act: (cubit) async {
      cubit.onSearchQueryChanged('query');
      await cubit.searchPlaceSuggestions();
      cubit.resetPlaceSuggestions();
    },
    expect: () => [
      const SearchFormState(
        searchQuery: 'query',
      ),
      const SearchFormState(
        status: SearchFormStateStatus.loading,
        searchQuery: 'query',
      ),
      const SearchFormState(
        status: SearchFormStateStatus.completed,
        searchQuery: 'query',
        placeSuggestions: [
          PlaceSuggestion(id: 'p1', name: 'place 1'),
          PlaceSuggestion(id: 'p2', name: 'place 2'),
        ],
      ),
      const SearchFormState(
        status: SearchFormStateStatus.completed,
        searchQuery: 'query',
        placeSuggestions: null,
      ),
    ],
  );
}
