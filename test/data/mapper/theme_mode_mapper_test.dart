import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/local_db/dto/theme_mode_dto.dart';
import 'package:motorbike_navigator/data/mapper/theme_mode_mapper.dart';
import 'package:motorbike_navigator/entity/settings.dart';

void main() {
  final mapper = ThemeModeMapper();

  group(
    'mapFromDto, ',
    () {
      test(
        'ThemeModeDto object with val set as ThemeModeDtoVal.light should be '
        'mapped to ThemeMode.light',
        () {
          const ThemeModeDto dto = ThemeModeDto(ThemeModeDtoVal.light);
          const ThemeMode expectedThemeMode = ThemeMode.light;

          final ThemeMode themeMode = mapper.mapFromDto(dto);

          expect(themeMode, expectedThemeMode);
        },
      );

      test(
        'ThemeModeDto object with val set as ThemeModeDtoVal.dark should be '
        'mapped to ThemeMode.dark',
        () {
          const ThemeModeDto dto = ThemeModeDto(ThemeModeDtoVal.dark);
          const ThemeMode expectedThemeMode = ThemeMode.dark;

          final ThemeMode themeMode = mapper.mapFromDto(dto);

          expect(themeMode, expectedThemeMode);
        },
      );
    },
  );

  group(
    'mapToDto, ',
    () {
      test(
        'ThemeMode.light should be mapped to ThemeModeDto object with val set '
        'as ThemeModeDtoVal.light',
        () {
          const ThemeMode themeMode = ThemeMode.light;
          const ThemeModeDto expectedDto = ThemeModeDto(ThemeModeDtoVal.light);

          final ThemeModeDto dto = mapper.mapToDto(themeMode);

          expect(dto, expectedDto);
        },
      );

      test(
        'ThemeMode.dark should be mapped to ThemeModeDto object with val set '
        'as ThemeModeDtoVal.dark',
        () {
          const ThemeMode themeMode = ThemeMode.dark;
          const ThemeModeDto expectedDto = ThemeModeDto(ThemeModeDtoVal.dark);

          final ThemeModeDto dto = mapper.mapToDto(themeMode);

          expect(dto, expectedDto);
        },
      );
    },
  );
}
