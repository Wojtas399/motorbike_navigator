import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/navigation.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

void main() {
  late RouteState state;

  setUp(() {
    state = const RouteState();
  });

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

  test(
    'copyWith status, '
    'should update status if new value has been passed and should copy current '
    'value if new value has not been passed',
    () {
      const RouteStateStatus expectedStatus = RouteStateStatus.searching;
      RouteState state = const RouteState();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, expectedStatus);
    },
  );

  test(
    'copyWith startPlaceSuggestion, '
    'should update startPlaceSuggestion if new value has been passed, '
    'should copy current value if new value has not been passed and '
    'should set null if passed value is null',
    () {
      const PlaceSuggestion expectedPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'place suggestion',
      );

      state = state.copyWith(startPlaceSuggestion: expectedPlaceSuggestion);
      final state2 = state.copyWith();
      final state3 = state.copyWith(startPlaceSuggestion: null);

      expect(state.startPlaceSuggestion, expectedPlaceSuggestion);
      expect(state2.startPlaceSuggestion, expectedPlaceSuggestion);
      expect(state3.startPlaceSuggestion, null);
    },
  );

  test(
    'copyWith destinationSuggestion, '
    'should update destinationSuggestion if new value has been passed, '
    'should copy current value if new value has not been passed and '
    'should set null if passed value is null',
    () {
      const PlaceSuggestion expectedPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'place suggestion',
      );

      state = state.copyWith(destinationSuggestion: expectedPlaceSuggestion);
      final state2 = state.copyWith();
      final state3 = state.copyWith(destinationSuggestion: null);

      expect(state.destinationSuggestion, expectedPlaceSuggestion);
      expect(state2.destinationSuggestion, expectedPlaceSuggestion);
      expect(state3.destinationSuggestion, null);
    },
  );

  test(
    'copyWith route, '
    'should update route if new value has been passed, '
    'should copy current value if new value has not been passed and '
    'should set null if passed value is null',
    () {
      const Route expectedRoute = Route(
        durationInSeconds: 10000,
        distanceInMeters: 1000,
        waypoints: [],
      );

      state = state.copyWith(route: expectedRoute);
      final state2 = state.copyWith();
      final state3 = state.copyWith(route: null);

      expect(state.route, expectedRoute);
      expect(state2.route, expectedRoute);
      expect(state3.route, null);
    },
  );
}
