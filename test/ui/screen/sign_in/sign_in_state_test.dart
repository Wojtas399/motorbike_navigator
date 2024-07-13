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

  test(
    'status.isUserAlreadySignedIn, '
    'should be true if status is set as userIsAlreadySignedIn',
    () {
      const SignInState state = SignInState(
        status: SignInStateStatus.userIsAlreadySignedIn,
      );

      expect(state.status.isUserAlreadySignedIn, true);
    },
  );

  test(
    'status.isUserAlreadySignedIn, '
    'should be false if status is set as loading',
    () {
      const SignInState state = SignInState(
        status: SignInStateStatus.loading,
      );

      expect(state.status.isUserAlreadySignedIn, false);
    },
  );

  test(
    'status.isUserAlreadySignedIn, '
    'should be false if status is set as completed',
    () {
      const SignInState state = SignInState(
        status: SignInStateStatus.completed,
      );

      expect(state.status.isUserAlreadySignedIn, false);
    },
  );
}
