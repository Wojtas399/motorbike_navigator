import 'package:injectable/injectable.dart';

import '../../../entity/settings.dart';
import '../../local_db/dto/theme_mode_dto.dart';
import '../../local_db/service/settings_shared_preferences_service.dart';
import '../../mapper/theme_mode_mapper.dart';
import '../item_repository.dart';
import 'settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl extends ItemRepository<Settings>
    implements SettingsRepository {
  final SettingsSharedPreferencesService _settingsSharedPreferencesService;
  final ThemeModeMapper _themeModeMapper;

  SettingsRepositoryImpl(
    this._settingsSharedPreferencesService,
    this._themeModeMapper,
  );

  @override
  Stream<Settings?> getSettings() async* {
    await _loadSettings();
    await for (final item in repositoryState$) {
      yield item;
    }
  }

  @override
  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    final ThemeModeDto themeModeDto = _themeModeMapper.mapToDto(newThemeMode);
    await _settingsSharedPreferencesService.setThemeMode(themeModeDto);
    _updateThemeModeInState(newThemeMode);
  }

  Future<void> _loadSettings() async {
    final ThemeModeDto? themeModeDto =
        await _settingsSharedPreferencesService.loadThemeMode();
    if (themeModeDto == null) return;
    final ThemeMode themeMode = _themeModeMapper.mapFromDto(themeModeDto);
    final Settings settings = Settings(themeMode: themeMode);
    updateState(settings);
  }

  void _updateThemeModeInState(ThemeMode newThemeMode) {
    final Settings updatedSettings = Settings(
      themeMode: newThemeMode,
    );
    updateState(updatedSettings);
  }
}
