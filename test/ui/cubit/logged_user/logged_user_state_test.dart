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

  test(
    'status.isLoading, '
    'should be true if status is set as loading',
    () {
      const state = LoggedUserState(
        status: LoggedUserStateStatus.loading,
      );

      expect(state.status.isLoading, true);
    },
  );

  test(
    'status.isLoading, '
    'should be false if status is set as completed',
    () {
      const state = LoggedUserState(
        status: LoggedUserStateStatus.completed,
      );

      expect(state.status.isLoading, false);
    },
  );

  test(
    'copyWith status, '
    'should update status if new value has been passed, '
    'should copy current value if new value has not been passed',
    () {
      const LoggedUserStateStatus expectedStatus =
          LoggedUserStateStatus.completed;
      LoggedUserState state = const LoggedUserState();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, expectedStatus);
    },
  );

  test(
    'copyWith themeMode, '
    'should update themeMode if new value has been passed, '
    'should copy current value if new value has not been passed, '
    'should set themeMode as null if passed value is null',
    () {
      const ThemeMode expectedThemeMode = ThemeMode.dark;
      LoggedUserState state = const LoggedUserState();

      state = state.copyWith(themeMode: expectedThemeMode);
      final state2 = state.copyWith();
      final state3 = state2.copyWith(themeMode: null);

      expect(state.themeMode, expectedThemeMode);
      expect(state2.themeMode, expectedThemeMode);
      expect(state3.themeMode, null);
    },
  );
}
