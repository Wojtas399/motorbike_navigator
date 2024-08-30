import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/settings/settings_repository.dart';
import 'package:motorbike_navigator/entity/settings.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {
  MockSettingsRepository() {
    registerFallbackValue(ThemeMode.dark);
  }

  void mockGetSettings({
    Settings? expectedSettings,
  }) {
    when(
      getSettings,
    ).thenAnswer((_) => Stream.value(expectedSettings));
  }

  void mockSetThemeMode() {
    when(
      () => setThemeMode(any()),
    ).thenAnswer((_) => Future.value());
  }
}
