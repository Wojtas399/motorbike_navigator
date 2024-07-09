import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/mapper/user_mapper.dart';
import 'package:motorbike_navigator/entity/user.dart';

import '../../mock/data/mapper/mock_theme_mode_mapper.dart';

void main() {
  final themeModeMapper = MockThemeModeMapper();
  final mapper = UserMapper(themeModeMapper);
  const String id = 'u1';
  const ThemeMode themeMode = ThemeMode.dark;
  const ThemeModeDto themeModeDto = ThemeModeDto.dark;

  test(
    'mapFromDto, '
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
      themeModeMapper.mockMapFromDto(expectedThemeMode: themeMode);

      final User user = mapper.mapFromDto(userDto);

      expect(user, expectedUser);
    },
  );

  test(
    'mapToDto, '
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
      themeModeMapper.mockMapToDto(expectedThemeModeDto: themeModeDto);

      final UserDto userDto = mapper.mapToDto(user);

      expect(userDto, expectedUserDto);
    },
  );
}
