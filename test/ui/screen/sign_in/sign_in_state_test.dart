import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/screen/sign_in/cubit/sign_in_state.dart';

void main() {
  test(
    'default state',
    () {
      const SignInState expectedDefaultState = SignInState(
        status: SignInStateStatus.loading,
      );

      const SignInState defaultState = SignInState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isUserAlreadySignedIn, ',
    () {
      test(
        'should be true if status is set as userIsAlreadySignedIn',
        () {
          const SignInState state = SignInState(
            status: SignInStateStatus.userIsAlreadySignedIn,
          );

          expect(state.status.isUserAlreadySignedIn, true);
        },
      );

      test(
        'should be false if status is set as loading',
        () {
          const SignInState state = SignInState(
            status: SignInStateStatus.loading,
          );

          expect(state.status.isUserAlreadySignedIn, false);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const SignInState state = SignInState(
            status: SignInStateStatus.completed,
          );

          expect(state.status.isUserAlreadySignedIn, false);
        },
      );
    },
  );

  group(
    'copyWith status, ',
    () {
      const SignInStateStatus expectedStatus =
          SignInStateStatus.userIsAlreadySignedIn;
      SignInState state = const SignInState();

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
}
