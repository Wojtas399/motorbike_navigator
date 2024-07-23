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
      LoggedUserState? state;

      blocTest(
        'should emit state with light theme mode if current theme mode is null '
        'and then should emit previous state if logged user id has not been found',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetLoggedUserId(),
        act: (cubit) => cubit.switchThemeMode(),
        expect: () => [
          state = const LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: ThemeMode.light,
          ),
          state = state?.copyWith(
            status: LoggedUserStateStatus.loading,
            themeMode: null,
          ),
        ],
        verify: (_) => verify(() => authRepository.loggedUserId$).called(1),
      );

      blocTest(
        'should emit state with dark theme mode if current theme mode is light '
        'and then should emit previous state if logged user id has not been found',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockGetUserById(
            expectedUser: const User(
              id: loggedUserId,
              themeMode: ThemeMode.light,
            ),
          );
        },
        act: (cubit) async {
          cubit.initialize();
          authRepository.mockGetLoggedUserId(expectedLoggedUserId: null);
          await cubit.stream.first;
          cubit.switchThemeMode();
        },
        expect: () => [
          state = const LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: ThemeMode.light,
          ),
          state = state?.copyWith(
            themeMode: ThemeMode.dark,
          ),
          state = state?.copyWith(
            themeMode: ThemeMode.light,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with light theme mode if current theme mode is dark '
        'and then should emit previous state if logged user id has not been found',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockGetUserById(
            expectedUser: const User(
              id: loggedUserId,
              themeMode: ThemeMode.dark,
            ),
          );
        },
        act: (cubit) async {
          cubit.initialize();
          authRepository.mockGetLoggedUserId(expectedLoggedUserId: null);
          await cubit.stream.first;
          cubit.switchThemeMode();
        },
        expect: () => [
          state = const LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: ThemeMode.dark,
          ),
          state = state?.copyWith(
            themeMode: ThemeMode.light,
          ),
          state = state?.copyWith(
            themeMode: ThemeMode.dark,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with light theme mode if current theme mode is null '
        'and should call method from UserRepository to update theme mode to '
        'light if logged user id has been found',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockUpdateUserThemeMode();
        },
        act: (cubit) => cubit.switchThemeMode(),
        expect: () => [
          state = const LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: ThemeMode.light,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.updateUserThemeMode(
              userId: loggedUserId,
              themeMode: ThemeMode.light,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with dark theme mode if current theme mode is light '
        'and should call method from UserRepository to update theme mode to '
        'dark if logged user id has been found',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockGetUserById(
            expectedUser: const User(
              id: loggedUserId,
              themeMode: ThemeMode.light,
            ),
          );
          userRepository.mockUpdateUserThemeMode();
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          cubit.switchThemeMode();
        },
        expect: () => [
          state = const LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: ThemeMode.light,
          ),
          state = state?.copyWith(
            themeMode: ThemeMode.dark,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => userRepository.updateUserThemeMode(
              userId: loggedUserId,
              themeMode: ThemeMode.dark,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit state with light theme mode if current theme mode is dark '
        'and should call method from UserRepository to update theme mode to '
        'light if logged user id has been found',
        build: () => createCubit(),
        setUp: () {
          authRepository.mockGetLoggedUserId(
            expectedLoggedUserId: loggedUserId,
          );
          userRepository.mockGetUserById(
            expectedUser: const User(
              id: loggedUserId,
              themeMode: ThemeMode.dark,
            ),
          );
          userRepository.mockUpdateUserThemeMode();
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          cubit.switchThemeMode();
        },
        expect: () => [
          state = const LoggedUserState(
            status: LoggedUserStateStatus.completed,
            themeMode: ThemeMode.dark,
          ),
          state = state?.copyWith(
            themeMode: ThemeMode.light,
          ),
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(2);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => userRepository.updateUserThemeMode(
              userId: loggedUserId,
              themeMode: ThemeMode.light,
            ),
          ).called(1);
        },
      );
    },
  );
}
