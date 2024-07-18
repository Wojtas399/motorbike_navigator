import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/navigation.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = RouteState(
        status: RouteStateStatus.initial,
        startPlaceSuggestion: null,
        destinationSuggestion: null,
        route: null,
      );

      const defaultState = RouteState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'copyWith status, ',
    () {
      const RouteStateStatus expectedStatus = RouteStateStatus.searching;
      RouteState state = const RouteState();

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
    'copyWith startPlaceSuggestion, ',
    () {
      const PlaceSuggestion expectedPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'place suggestion',
      );
      RouteState state = const RouteState();

      test(
        'should update startPlaceSuggestion if new value has been passed, ',
        () {
          state = state.copyWith(startPlaceSuggestion: expectedPlaceSuggestion);

          expect(state.startPlaceSuggestion, expectedPlaceSuggestion);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.startPlaceSuggestion, expectedPlaceSuggestion);
        },
      );

      test(
        'should set startPlaceSuggestion as null if passed value is null',
        () {
          state = state.copyWith(startPlaceSuggestion: null);

          expect(state.startPlaceSuggestion, null);
        },
      );
    },
  );

  group(
    'copyWith destinationSuggestion, ',
    () {
      const PlaceSuggestion expectedPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'place suggestion',
      );
      RouteState state = const RouteState();

      test(
        'should update destinationSuggestion if new value has been passed, ',
        () {
          state = state.copyWith(
            destinationSuggestion: expectedPlaceSuggestion,
          );

          expect(state.destinationSuggestion, expectedPlaceSuggestion);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.destinationSuggestion, expectedPlaceSuggestion);
        },
      );

      test(
        'should set startPlaceSuggestion as null if passed value is null',
        () {
          state = state.copyWith(destinationSuggestion: null);

          expect(state.destinationSuggestion, null);
        },
      );
    },
  );

  group(
    'copyWith route, ',
    () {
      const Route expectedRoute = Route(
        durationInSeconds: 10000,
        distanceInMeters: 1000,
        waypoints: [],
      );
      RouteState state = const RouteState();

      test(
        'should update route if new value has been passed, ',
        () {
          state = state.copyWith(route: expectedRoute);

          expect(state.route, expectedRoute);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.route, expectedRoute);
        },
      );

      test(
        'should set startPlaceSuggestion as null if passed value is null',
        () {
          state = state.copyWith(route: null);

          expect(state.route, null);
        },
      );
    },
  );
}
