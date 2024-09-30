import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/settings/settings_repository.dart';
import '../../../entity/settings.dart';

@injectable
class SettingsCubit extends Cubit<Settings?> {
  final SettingsRepository _settingsRepository;

  SettingsCubit(this._settingsRepository) : super(null);

  Future<void> initialize() async {
    final Stream<Settings?> settings$ = _settingsRepository.getSettings();
    await for (final settings in settings$) {
      if (settings != null) {
        emit(settings);
      } else {
        await _setDefaultSettings();
      }
    }
  }

  Future<void> switchThemeMode() async {
    final ThemeMode? currentThemeMode = state?.themeMode;
    if (currentThemeMode == null) return;
    final ThemeMode newThemeMode = switch (currentThemeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
    };
    await _settingsRepository.setThemeMode(newThemeMode);
  }

  Future<void> _setDefaultSettings() async {
    await _settingsRepository.setThemeMode(ThemeMode.light);
  }
}
