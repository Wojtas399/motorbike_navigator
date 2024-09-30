import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/theme_mode_dto.dart';
import 'package:motorbike_navigator/data/mapper/theme_mode_mapper.dart';
import 'package:motorbike_navigator/entity/settings.dart';

class MockThemeModeMapper extends Mock implements ThemeModeMapper {
  MockThemeModeMapper() {
    registerFallbackValue(
      const ThemeModeDto(ThemeModeDtoVal.dark),
    );
    registerFallbackValue(
      ThemeMode.dark,
    );
  }

  void mockMapFromDto({
    required ThemeMode expectedThemeMode,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedThemeMode);
  }

  void mockMapToDto({
    required ThemeModeDto expectedThemeModeDto,
  }) {
    when(
      () => mapToDto(any()),
    ).thenReturn(expectedThemeModeDto);
  }
}
