import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/theme_mode_dto.dart';
import 'package:motorbike_navigator/data/local_db/service/settings_shared_preferences_service.dart';

class MockSettingsSharedPreferencesService extends Mock
    implements SettingsSharedPreferencesService {
  void mockLoadThemeMode({
    ThemeModeDto? expectedThemeModeDto,
  }) {
    when(loadThemeMode).thenAnswer((_) => Future.value(expectedThemeModeDto));
  }

  void mockSetThemeMode() {
    when(
      () => setThemeMode(any()),
    ).thenAnswer((_) => Future.value());
  }
}
