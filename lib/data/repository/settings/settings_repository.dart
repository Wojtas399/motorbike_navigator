import '../../../entity/settings.dart';

abstract interface class SettingsRepository {
  Stream<Settings?> getSettings();

  Future<void> setThemeMode(ThemeMode newThemeMode);
}
