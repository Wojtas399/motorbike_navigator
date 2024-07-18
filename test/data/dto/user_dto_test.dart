import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';

void main() {
  const String id = 'u1';
  const ThemeModeDto themeModeDto = ThemeModeDto.dark;
  final Map<String, Object?> userJson = {
    'themeMode': themeModeDto.name,
  };

  test(
    'fromJson, '
    'should map json object to UserDto object without changing id',
    () {
      const UserDto expectedDto = UserDto(
        themeMode: themeModeDto,
      );

      final UserDto dto = UserDto.fromJson(userJson);

      expect(dto, expectedDto);
    },
  );

  test(
    'fromFirebaseFirestore, '
    'should map json object to UserDto object with changed id',
    () {
      const UserDto expectedDto = UserDto(
        id: id,
        themeMode: themeModeDto,
      );

      final UserDto dto = UserDto.fromFirebaseFirestore(
        id: id,
        json: userJson,
      );

      expect(dto, expectedDto);
    },
  );

  test(
    'toJson, '
    'should map UserDot object to json object without id key',
    () {
      const UserDto driveDto = UserDto(
        id: id,
        themeMode: themeModeDto,
      );

      final Map<String, Object?> json = driveDto.toJson();

      expect(json, userJson);
    },
  );
}
