import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/user.dart';
import 'package:motorbike_navigator/ui/cubit/logged_user/logged_user_state.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = LoggedUserState(
        status: LoggedUserStateStatus.loading,
        themeMode: null,
      );

      const defaultState = LoggedUserState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading, ',
    () {
      test(
        'should be true if status is set as loading',
        () {
          const state = LoggedUserState(
            status: LoggedUserStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = LoggedUserState(
            status: LoggedUserStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'copyWith status, ',
    () {
      const expectedStatus = LoggedUserStateStatus.completed;
      LoggedUserState state = const LoggedUserState();

      test(
        'should update status if new value has been passed',
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
    'copyWith themeMode, ',
    () {
      const ThemeMode expectedThemeMode = ThemeMode.dark;
      LoggedUserState state = const LoggedUserState();

      test(
        'should update startDateTime if new value has been passed',
        () {
          state = state.copyWith(themeMode: expectedThemeMode);

          expect(state.themeMode, expectedThemeMode);
        },
      );

      test(
        'should copy current value if new value has not been passed',
        () {
          state = state.copyWith();

          expect(state.themeMode, expectedThemeMode);
        },
      );

      test(
        'should set startDateTime as null if passed value is null',
        () {
          state = state.copyWith(themeMode: null);

          expect(state.themeMode, null);
        },
      );
    },
  );
}
