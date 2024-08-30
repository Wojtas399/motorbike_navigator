import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/local_db/dto/theme_mode_dto.dart';

void main() {
  group(
    'fromString, ',
    () {
      test(
        'light str should be mapped to ThemeModeDto object with val param set '
        'as light',
        () {
          const String val = 'light';
          const ThemeModeDto expectedDto = ThemeModeDto(ThemeModeDtoVal.light);

          final ThemeModeDto dto = ThemeModeDto.fromString(val);

          expect(dto, expectedDto);
        },
      );

      test(
        'dark str should be mapped to ThemeModeDto object with val param set '
        'as dark',
        () {
          const String val = 'dark';
          const ThemeModeDto expectedDto = ThemeModeDto(ThemeModeDtoVal.dark);

          final ThemeModeDto dto = ThemeModeDto.fromString(val);

          expect(dto, expectedDto);
        },
      );
    },
  );

  group(
    'toString, ',
    () {
      test(
        'ThemeModeDto object with val param set as light should be mapped to '
        'light str',
        () {
          const ThemeModeDto dto = ThemeModeDto(ThemeModeDtoVal.light);
          const String expectedStr = 'light';

          final String str = dto.toString();

          expect(str, expectedStr);
        },
      );

      test(
        'ThemeModeDto object with val param set as dark should be mapped to '
        'dark str',
        () {
          const ThemeModeDto dto = ThemeModeDto(ThemeModeDtoVal.dark);
          const String expectedStr = 'dark';

          final String str = dto.toString();

          expect(str, expectedStr);
        },
      );
    },
  );
}
