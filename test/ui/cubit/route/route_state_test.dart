import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/map_point.dart';
import 'package:motorbike_navigator/entity/route_suggestions.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = RouteState(
        status: RouteStateStatus.initial,
        startPoint: UserLocationPoint(),
        endPoint: null,
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
    'copyWith startPoint, ',
    () {
      const MapPoint expectedStartPoint = SelectedPlacePoint(
        id: 'p1',
        name: 'place suggestion',
      );
      RouteState state = const RouteState();

      test(
        'should update startPoint if new value has been passed, ',
        () {
          state = state.copyWith(startPoint: expectedStartPoint);

          expect(state.startPoint, expectedStartPoint);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.startPoint, expectedStartPoint);
        },
      );

      test(
        'should set startPoint as null if passed value is null',
        () {
          state = state.copyWith(startPoint: null);

          expect(state.startPoint, null);
        },
      );
    },
  );

  group(
    'copyWith endPoint, ',
    () {
      const MapPoint expectedEndPoint = SelectedPlacePoint(
        id: 'p1',
        name: 'place suggestion',
      );
      RouteState state = const RouteState();

      test(
        'should update endPoint if new value has been passed, ',
        () {
          state = state.copyWith(
            endPoint: expectedEndPoint,
          );

          expect(state.endPoint, expectedEndPoint);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.endPoint, expectedEndPoint);
        },
      );

      test(
        'should set endPoint as null if passed value is null',
        () {
          state = state.copyWith(endPoint: null);

          expect(state.endPoint, null);
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
