import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/theme_mode_dto.dart';
import 'package:motorbike_navigator/data/repository/settings/settings_repository_impl.dart';
import 'package:motorbike_navigator/entity/settings.dart';

import '../../mock/data/local_db/mock_settings_shared_preferences_service.dart';
import '../../mock/data/mapper/mock_theme_mode_mapper.dart';

void main() {
  final settingsSharedPreferencesService =
      MockSettingsSharedPreferencesService();
  final themeModeMapper = MockThemeModeMapper();
  late SettingsRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = SettingsRepositoryImpl(
      settingsSharedPreferencesService,
      themeModeMapper,
    );
  });

  tearDown(() {
    reset(settingsSharedPreferencesService);
    reset(themeModeMapper);
  });

  group(
    'getSettings, ',
    () {
      test(
        'should load settings from local db and if they exist should add them '
        'to repo state and emit them',
        () async {
          const ThemeModeDto themeModeDto = ThemeModeDto(ThemeModeDtoVal.dark);
          const ThemeMode themeMode = ThemeMode.dark;
          const Settings expectedSettings = Settings(
            themeMode: themeMode,
          );
          settingsSharedPreferencesService.mockLoadThemeMode(
            expectedThemeModeDto: themeModeDto,
          );
          themeModeMapper.mockMapFromDto(
            expectedThemeMode: themeMode,
          );

          final Stream<Settings?> settings$ = repositoryImpl.getSettings();

          expect(
            await settings$.first,
            expectedSettings,
          );
          expect(
            await repositoryImpl.repositoryState$.first,
            expectedSettings,
          );
        },
      );

      test(
        'should load settings from local db and if they do not exist should '
        'not change repo state',
        () async {
          const ThemeModeDto themeModeDto = ThemeModeDto(ThemeModeDtoVal.dark);
          const ThemeMode themeMode = ThemeMode.dark;
          const Settings settings = Settings(
            themeMode: themeMode,
          );
          settingsSharedPreferencesService.mockLoadThemeMode(
            expectedThemeModeDto: themeModeDto,
          );
          themeModeMapper.mockMapFromDto(
            expectedThemeMode: themeMode,
          );

          final Stream<Settings?> settings$ = repositoryImpl.getSettings();
          await settings$.first;
          settingsSharedPreferencesService.mockLoadThemeMode();
          final Stream<Settings?> settings2$ = repositoryImpl.getSettings();

          expect(
            await settings2$.first,
            settings,
          );
          expect(
            await repositoryImpl.repositoryState$.first,
            settings,
          );
        },
      );
    },
  );

  test(
    'updateThemeMode, '
    'should call method from SettingsSharedPreferencesService to set theme '
    'mode and should update theme mode in settings object placed in repo state',
    () async {
      const ThemeMode newThemeMode = ThemeMode.dark;
      const ThemeModeDto newThemeModeDto = ThemeModeDto(ThemeModeDtoVal.dark);
      const Settings expectedUpdatedSettings = Settings(
        themeMode: newThemeMode,
      );
      themeModeMapper.mockMapToDto(
        expectedThemeModeDto: newThemeModeDto,
      );
      settingsSharedPreferencesService.mockSetThemeMode();

      await repositoryImpl.updateThemeMode(newThemeMode);

      expect(
        await repositoryImpl.repositoryState$.first,
        expectedUpdatedSettings,
      );
      verify(
        () => settingsSharedPreferencesService.setThemeMode(newThemeModeDto),
      ).called(1);
    },
  );
}
