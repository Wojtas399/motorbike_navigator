import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/user.dart';
import 'package:motorbike_navigator/ui/cubit/logged_user/logged_user_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/logged_user/logged_user_state.dart';

import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  LoggedUserCubit createCubit() => LoggedUserCubit(
        authRepository,
        userRepository,
      );

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'id of logged user is null, '
    'should emit LoggedUserDoesNotExist status',
    build: () => createCubit(),
    setUp: () => authRepository.mockGetLoggedUserId(expectedLoggedUserId: null),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const LoggedUserStateLoggedUserDoesNotExist(),
    ],
    verify: (_) => verify(
      () => authRepository.loggedUserId$,
    ).called(1),
  );

  blocTest(
    'initialize, '
    'data of logged user exist, '
    'should emit Completed status',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: 'u1');
      userRepository.mockGetUserById(
        expectedUser: const User(id: 'u1', themeMode: ThemeMode.light),
      );
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const LoggedUserStateCompleted(),
    ],
    verify: (_) {
      verify(
        () => authRepository.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.getUserById(userId: 'u1'),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'data of logged user not exist, '
    'should add user data with light mode set as system and should emit '
    'Completed status',
    build: () => createCubit(),
    setUp: () {
      authRepository.mockGetLoggedUserId(expectedLoggedUserId: 'u1');
      userRepository.mockGetUserById(expectedUser: null);
      userRepository.mockAddUser();
    },
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const LoggedUserStateCompleted(),
    ],
    verify: (_) {
      verify(
        () => authRepository.loggedUserId$,
      ).called(1);
      verify(
        () => userRepository.getUserById(userId: 'u1'),
      ).called(1);
      verify(
        () => userRepository.addUser(
          userId: 'u1',
          themeMode: ThemeMode.system,
        ),
      ).called(1);
    },
  );
}
