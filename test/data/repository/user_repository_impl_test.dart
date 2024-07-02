import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/repository/user/user_repository_impl.dart';
import 'package:motorbike_navigator/entity/user.dart';

import '../../mock/data/firebase/mock_firebase_user_service.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  late UserRepositoryImpl repositoryImpl;
  const String userId = 'u1';

  setUp(() {
    repositoryImpl = UserRepositoryImpl(dbUserService);
  });

  tearDown(() {
    reset(dbUserService);
  });

  test(
    'getUserById, '
    'should load user data from db, should add its data to repo state '
    'and should emit them if user does not exist in repo state, '
    'should only emit user if it exists in repo state',
    () async {
      const UserDto expectedUserDto = UserDto(
        id: userId,
        themeMode: ThemeModeDto.light,
      );
      const User expectedUser = User(
        id: userId,
        themeMode: ThemeMode.light,
      );
      dbUserService.mockFetchUserById(expectedUserDto: expectedUserDto);

      final Stream<User?> user1$ = repositoryImpl.getUserById(userId: userId);
      final Stream<User?> user2$ = repositoryImpl.getUserById(userId: userId);

      expect(await user1$.first, expectedUser);
      expect(await user2$.first, expectedUser);
      expect(await repositoryImpl.repositoryState$.first, [expectedUser]);
      verify(
        () => dbUserService.fetchUserById(userId: userId),
      ).called(1);
    },
  );

  test(
    'addUser, '
    'should add user data to db and to repository state',
    () async {
      const ThemeMode themeMode = ThemeMode.dark;
      const ThemeModeDto themeModeDto = ThemeModeDto.dark;
      const UserDto addedUserDto = UserDto(
        id: userId,
        themeMode: themeModeDto,
      );
      const User addedUser = User(
        id: userId,
        themeMode: themeMode,
      );
      dbUserService.mockAddUser(expectedAddedUserDto: addedUserDto);

      await repositoryImpl.addUser(
        userId: userId,
        themeMode: themeMode,
      );

      expect(repositoryImpl.repositoryState$, emits([addedUser]));
      verify(
        () => dbUserService.addUser(
          userId: userId,
          themeMode: themeModeDto,
        ),
      ).called(1);
    },
  );

  test(
    'updateUserThemeMode, '
    'user does not exists in repo state, '
    'should finish method call',
    () async {
      await repositoryImpl.updateUserThemeMode(
        userId: userId,
        themeMode: ThemeMode.dark,
      );

      verifyNever(
        () => dbUserService.updateUserThemeMode(
          userId: userId,
          themeMode: any(named: 'themeMode'),
        ),
      );
    },
  );

  test(
    'updateUserThemeMode, '
    'updated user is not returned from db, '
    'should throw exception',
    () async {
      const UserDto existingUserDto = UserDto(
        id: userId,
        themeMode: ThemeModeDto.light,
      );
      const ThemeMode newThemeMode = ThemeMode.system;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.system;
      const expectedException = "Updated user's data not found";
      dbUserService.mockFetchUserById(expectedUserDto: existingUserDto);
      dbUserService.mockUpdateUserThemeMode(expectedUpdatedUserDto: null);

      Object? exception;
      try {
        final user$ = repositoryImpl.getUserById(userId: userId);
        await user$.first;
        await repositoryImpl.updateUserThemeMode(
          userId: userId,
          themeMode: newThemeMode,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => dbUserService.updateUserThemeMode(
          userId: userId,
          themeMode: newThemeModeDto,
        ),
      ).called(1);
    },
  );

  test(
    'updateUserThemeMode, '
    'should update user in db and in repo state',
    () async {
      const UserDto existingUserDto = UserDto(
        id: userId,
        themeMode: ThemeModeDto.dark,
      );
      const ThemeMode newThemeMode = ThemeMode.system;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.system;
      const User updatedUser = User(
        id: userId,
        themeMode: newThemeMode,
      );
      const UserDto updatedUserDto = UserDto(
        id: userId,
        themeMode: newThemeModeDto,
      );
      dbUserService.mockFetchUserById(expectedUserDto: existingUserDto);
      dbUserService.mockUpdateUserThemeMode(
        expectedUpdatedUserDto: updatedUserDto,
      );

      final user$ = repositoryImpl.getUserById(userId: userId);
      await user$.first;
      await repositoryImpl.updateUserThemeMode(
        userId: userId,
        themeMode: newThemeMode,
      );

      expect(
        await repositoryImpl.repositoryState$.first,
        [updatedUser],
      );
      verify(
        () => dbUserService.updateUserThemeMode(
          userId: userId,
          themeMode: newThemeModeDto,
        ),
      ).called(1);
    },
  );
}
