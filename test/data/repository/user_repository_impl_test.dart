import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/repository/user/user_repository_impl.dart';
import 'package:motorbike_navigator/entity/user.dart';

import '../../mock/data/firebase/mock_firebase_user_service.dart';
import '../../mock/data/mapper/mock_theme_mode_mapper.dart';
import '../../mock/data/mapper/mock_user_mapper.dart';

void main() {
  final dbUserService = MockFirebaseUserService();
  final themeModeMapper = MockThemeModeMapper();
  final userMapper = MockUserMapper();
  late UserRepositoryImpl repositoryImpl;
  const String userId = 'u1';

  setUp(() {
    repositoryImpl = UserRepositoryImpl(
      dbUserService,
      themeModeMapper,
      userMapper,
    );
  });

  tearDown(() {
    reset(dbUserService);
    reset(themeModeMapper);
    reset(userMapper);
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
      userMapper.mockMapFromDto(expectedUser: expectedUser);

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
      themeModeMapper.mockMapToDto(expectedThemeModeDto: themeModeDto);
      dbUserService.mockAddUser(expectedAddedUserDto: addedUserDto);
      userMapper.mockMapFromDto(expectedUser: addedUser);

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
      const User existingUser = User(
        id: userId,
        themeMode: ThemeMode.light,
      );
      const ThemeMode newThemeMode = ThemeMode.dark;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.dark;
      const expectedException = "Updated user's data not found";
      dbUserService.mockFetchUserById(expectedUserDto: existingUserDto);
      userMapper.mockMapFromDto(expectedUser: existingUser);
      themeModeMapper.mockMapToDto(expectedThemeModeDto: newThemeModeDto);
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
      const ThemeMode newThemeMode = ThemeMode.light;
      const ThemeModeDto newThemeModeDto = ThemeModeDto.light;
      const User updatedUser = User(
        id: userId,
        themeMode: newThemeMode,
      );
      const UserDto updatedUserDto = UserDto(
        id: userId,
        themeMode: newThemeModeDto,
      );
      dbUserService.mockFetchUserById(expectedUserDto: existingUserDto);
      themeModeMapper.mockMapToDto(expectedThemeModeDto: newThemeModeDto);
      dbUserService.mockUpdateUserThemeMode(
        expectedUpdatedUserDto: updatedUserDto,
      );
      userMapper.mockMapFromDto(expectedUser: updatedUser);

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
