import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/user.dart';
import 'package:motorbike_navigator/ui/cubit/logged_user/logged_user_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/logged_user/logged_user_state.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

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

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      const User loggedUser = User(
        id: loggedUserId,
        themeMode: ThemeMode.dark,
      );

      blocTest(
        'should not emit anything if logged user id is null',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(),
        act: (cubit) => cubit.initialize(),
        expect: () => [],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
      );

      blocTest(
        'should call method from UserRepository to add user with theme mode set '
        'as light',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockGetUserById();
          userRepository.mockAddUser();
        },
        act: (cubit) => cubit.initialize(),
        expect: () => const [
          LoggedUserState(
            status: LoggedUserStateStatus.completed,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => userRepository.addUser(
              userId: loggedUserId,
              themeMode: ThemeMode.light,
            ),
          ).called(1);
        },
      );

      blocTest(
        "should emit logged user's theme mode if its data exist",
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockGetUserById(expectedUser: loggedUser);
        },
        act: (cubit) => cubit.initialize(),
        expect: () => [
          LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: loggedUser.themeMode,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  group(
    'changeThemeMode',
    () {
      const String loggedUserId = 'u1';
      const ThemeMode newThemeMode = ThemeMode.dark;
      const LoggedUserState stateWithNewThemeMode = LoggedUserState(
        status: LoggedUserStateStatus.completed,
        themeMode: newThemeMode,
      );

      blocTest(
        'should emit state with new theme mode and then should emit previous '
        'state if logged user id has not been found',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(),
        act: (cubit) => cubit.changeThemeMode(newThemeMode),
        expect: () => const [
          stateWithNewThemeMode,
          LoggedUserState(),
        ],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
      );

      blocTest(
        'should emit state with new theme mode and should call method from '
        'UserRepository to update theme mode if logged user id has been found',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockUpdateUserThemeMode();
        },
        act: (cubit) => cubit.changeThemeMode(newThemeMode),
        expect: () => const [
          stateWithNewThemeMode,
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.updateUserThemeMode(
              userId: loggedUserId,
              themeMode: newThemeMode,
            ),
          ).called(1);
        },
      );
    },
  );
}
