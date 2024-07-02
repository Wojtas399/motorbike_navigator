import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/mapper/user_mapper.dart';
import 'package:motorbike_navigator/entity/user.dart';

void main() {
  const String id = 'u1';
  const ThemeMode themeMode = ThemeMode.dark;
  const ThemeModeDto themeModeDto = ThemeModeDto.dark;

  test(
    'mapUserFromDto, '
    'should map UserDto model to User model',
    () {
      const UserDto userDto = UserDto(
        id: id,
        themeMode: themeModeDto,
      );
      const User expectedUser = User(
        id: id,
        themeMode: themeMode,
      );

      final User user = mapUserFromDto(userDto);

      expect(user, expectedUser);
    },
  );

  test(
    'mapUserToDto, '
    'should map User model to UserDto model',
    () {
      const User user = User(
        id: id,
        themeMode: themeMode,
      );
      const UserDto expectedUserDto = UserDto(
        id: id,
        themeMode: themeModeDto,
      );

      final UserDto userDto = mapUserToDto(user);

      expect(userDto, expectedUserDto);
    },
  );
}
