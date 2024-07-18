import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/screen/search_form/cubit/search_form_state.dart';

void main() {
  test(
    'default state',
    () {
      const SearchFormState expectedDefaultState = SearchFormState(
        status: SearchFormStateStatus.completed,
        searchQuery: '',
        placeSuggestions: null,
      );

      const defaultState = SearchFormState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should be true if status is set as loading',
        () {
          const state = SearchFormState(status: SearchFormStateStatus.loading);

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = SearchFormState(
            status: SearchFormStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'status.isCompleted, ',
    () {
      test(
        'should be true if status is set as completed',
        () {
          const state = SearchFormState(
            status: SearchFormStateStatus.completed,
          );

          expect(state.status.isCompleted, true);
        },
      );

      test(
        'should be false if status is set as loading',
        () {
          const state = SearchFormState(status: SearchFormStateStatus.loading);

          expect(state.status.isCompleted, false);
        },
      );
    },
  );

  group(
    'copyWith status, ',
    () {
      const expectedStatus = SearchFormStateStatus.loading;
      SearchFormState state = const SearchFormState();

      test(
        'should update status if new value has been passed, ',
        () {
          state = state.copyWith(status: expectedStatus);

          expect(state.status, expectedStatus);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.status, expectedStatus);
        },
      );
    },
  );

  group(
    'copyWith searchQuery, ',
    () {
      const expectedSearchQuery = 'query';
      SearchFormState state = const SearchFormState();

      test(
        'should update status if new value has been passed, ',
        () {
          state = state.copyWith(searchQuery: expectedSearchQuery);

          expect(state.searchQuery, expectedSearchQuery);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.searchQuery, expectedSearchQuery);
        },
      );
    },
  );

  group(
    'copyWith placeSuggestions, ',
    () {
      const expectedPlaceSuggestions = [
        PlaceSuggestion(id: 'p1', name: 'place 1'),
      ];
      SearchFormState state = const SearchFormState();

      test(
        'should update status if new value has been passed, ',
        () {
          state = state.copyWith(placeSuggestions: expectedPlaceSuggestions);

          expect(state.placeSuggestions, expectedPlaceSuggestions);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.placeSuggestions, expectedPlaceSuggestions);
        },
      );

      test(
        'should set placeSuggestions as null if passed value is null',
        () {
          state = state.copyWith(placeSuggestions: null);

          expect(state.placeSuggestions, null);
        },
      );
    },
  );
}
