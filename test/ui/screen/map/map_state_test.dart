import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_state.dart';

void main() {
  test(
    'default state',
    () {
      const MapState expectedState = MapState(
        status: MapStateStatus.loading,
        centerLocation: null,
        userLocation: null,
      );

      const state = MapState();

      expect(state, expectedState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should be true if status is set as loading',
        () {
          const MapState state = MapState(status: MapStateStatus.loading);

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const MapState state = MapState(status: MapStateStatus.completed);

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'focusMode.isFollowingUserLocation, ',
    () {
      test(
        'should be true if focusMode is set as followUserLocation',
        () {
          const MapState state = MapState(
            focusMode: MapFocusMode.followUserLocation,
          );

          expect(state.focusMode.isFollowingUserLocation, true);
        },
      );

      test(
        'should be false if focusMode is set as free',
        () {
          const MapState state = MapState(
            focusMode: MapFocusMode.free,
          );

          expect(state.focusMode.isFollowingUserLocation, false);
        },
      );
    },
  );

  group(
    'copyWith status, ',
    () {
      const MapStateStatus expectedStatus = MapStateStatus.completed;
      MapState state = const MapState();

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
    'copyWith focusMode, ',
    () {
      const MapFocusMode expectedFocusMode = MapFocusMode.followUserLocation;
      MapState state = const MapState();

      test(
        'should update focusMode if new value has been passed, ',
        () {
          state = state.copyWith(focusMode: expectedFocusMode);

          expect(state.focusMode, expectedFocusMode);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.focusMode, expectedFocusMode);
        },
      );
    },
  );

  group(
    'copyWith centerLocation, ',
    () {
      const Coordinates expectedCenterLocation = Coordinates(50, 19);
      MapState state = const MapState();

      test(
        'should update centerLocation if new value has been passed',
        () {
          state = state.copyWith(centerLocation: expectedCenterLocation);

          expect(state.centerLocation, expectedCenterLocation);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.centerLocation, expectedCenterLocation);
        },
      );

      test(
        'should set centerLocation as null if passed value is null',
        () {
          state = state.copyWith(centerLocation: null);

          expect(state.centerLocation, null);
        },
      );
    },
  );

  group(
    'copyWith userLocation, ',
    () {
      const Coordinates expectedUserLocation = Coordinates(50, 19);
      MapState state = const MapState();

      test(
        'should update userLocation if new value has been passed',
        () {
          state = state.copyWith(userLocation: expectedUserLocation);

          expect(state.userLocation, expectedUserLocation);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.userLocation, expectedUserLocation);
        },
      );

      test(
        'should set userLocation as null if passed value is null',
        () {
          state = state.copyWith(userLocation: null);

          expect(state.userLocation, null);
        },
      );
    },
  );
}
