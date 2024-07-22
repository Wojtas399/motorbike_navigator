import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/navigation.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = RouteState(
        status: RouteStateStatus.initial,
        startPlace: UserLocationRoutePlace(),
        destination: null,
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
    'copyWith startPlace, ',
    () {
      const RoutePlace expectedStartPlace = SelectedRoutePlace(
        id: 'p1',
        name: 'place suggestion',
      );
      RouteState state = const RouteState();

      test(
        'should update startPlace if new value has been passed, ',
        () {
          state = state.copyWith(startPlace: expectedStartPlace);

          expect(state.startPlace, expectedStartPlace);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.startPlace, expectedStartPlace);
        },
      );

      test(
        'should set startPlace as null if passed value is null',
        () {
          state = state.copyWith(startPlace: null);

          expect(state.startPlace, null);
        },
      );
    },
  );

  group(
    'copyWith destinationSuggestion, ',
    () {
      const RoutePlace expectedDestination = SelectedRoutePlace(
        id: 'p1',
        name: 'place suggestion',
      );
      RouteState state = const RouteState();

      test(
        'should update destination if new value has been passed, ',
        () {
          state = state.copyWith(
            destination: expectedDestination,
          );

          expect(state.destination, expectedDestination);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.destination, expectedDestination);
        },
      );

      test(
        'should set destination as null if passed value is null',
        () {
          state = state.copyWith(destination: null);

          expect(state.destination, null);
        },
      );
    },
  );

  group(
    'copyWith route, ',
    () {
      const Route expectedRoute = Route(
        duration: Duration(minutes: 10),
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
