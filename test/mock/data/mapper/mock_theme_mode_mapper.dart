import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/mapper/theme_mode_mapper.dart';
import 'package:motorbike_navigator/entity/user.dart';

class MockThemeModeMapper extends Mock implements ThemeModeMapper {
  MockThemeModeMapper() {
    registerFallbackValue(ThemeMode.light);
    registerFallbackValue(ThemeModeDto.light);
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
