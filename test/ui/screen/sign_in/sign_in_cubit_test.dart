import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/screen/sign_in/cubit/sign_in_cubit.dart';
import 'package:motorbike_navigator/ui/screen/sign_in/cubit/sign_in_state.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';

void main() {
  final authRepository = MockAuthRepository();

  SignInCubit createCubit() => SignInCubit(authRepository);

  tearDown(() {
    reset(authRepository);
  });

  blocTest(
    'initialize, '
    'logged user id is not null, '
    'should emit state with status set to userIsAlreadySignedIn',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(
      expectedLoggedUserId: 'u1',
    ),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const SignInState(
        status: SignInStateStatus.userIsAlreadySignedIn,
      ),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'logged user id is null, '
    'should emit state with status set to completed',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(
      expectedLoggedUserId: null,
    ),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const SignInState(
        status: SignInStateStatus.completed,
      ),
    ],
    verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
  );

  blocTest(
    'signInWithGoogle, '
    'should call method from AuthRepository to sign in with google',
    build: () => createCubit(),
    setUp: () => authRepository.mockSignInWithGoogle(),
    act: (cubit) async => await cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(
        status: SignInStateStatus.loading,
      ),
    ],
    verify: (_) => verify(authRepository.signInWithGoogle).called(1),
  );
}
