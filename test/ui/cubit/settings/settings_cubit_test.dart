import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/settings.dart';
import 'package:motorbike_navigator/ui/cubit/settings/settings_cubit.dart';
import 'package:rxdart/rxdart.dart';

import '../../../mock/data/repository/mock_settings_repository.dart';

void main() {
  final settingsRepository = MockSettingsRepository();

  SettingsCubit createCubit() => SettingsCubit(settingsRepository);

  tearDown(() {
    reset(settingsRepository);
  });

  group(
    'initialize, ',
    () {
      const Settings defaultSettings = Settings(
        themeMode: ThemeMode.light,
      );
      const Settings updatedSettings = Settings(
        themeMode: ThemeMode.dark,
      );
      final settings$ = BehaviorSubject<Settings?>.seeded(null);

      blocTest(
        'should listen to settings from SettingsRepository and emit them if '
        'they exist else should initialize default settings',
        build: () => createCubit(),
        setUp: () {
          when(
            settingsRepository.getSettings,
          ).thenAnswer((_) => settings$.stream);
          settingsRepository.mockSetThemeMode();
        },
        act: (cubit) {
          cubit.initialize();
          settings$.add(defaultSettings);
          settings$.add(updatedSettings);
        },
        expect: () => [
          defaultSettings,
          updatedSettings,
        ],
        verify: (_) => verify(
          () => settingsRepository.setThemeMode(
            defaultSettings.themeMode,
          ),
        ).called(1),
      );
    },
  );

  group(
    'switchThemeMode, ',
    () {
      blocTest(
        'should do nothing if state is null',
        build: () => createCubit(),
        act: (cubit) async => await cubit.switchThemeMode(),
        expect: () => [],
      );

      blocTest(
        'current theme mode is light, '
        'should call method from SettingsRepository to set theme mode to dark',
        build: () => createCubit(),
        setUp: () {
          settingsRepository.mockGetSettings(
            expectedSettings: const Settings(
              themeMode: ThemeMode.light,
            ),
          );
          settingsRepository.mockSetThemeMode();
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.switchThemeMode();
        },
        expect: () => [
          const Settings(
            themeMode: ThemeMode.light,
          ),
        ],
        verify: (_) => verify(
          () => settingsRepository.setThemeMode(ThemeMode.dark),
        ).called(1),
      );

      blocTest(
        'current theme mode is dark, '
        'should call method from SettingsRepository to set theme mode to light',
        build: () => createCubit(),
        setUp: () {
          settingsRepository.mockGetSettings(
            expectedSettings: const Settings(
              themeMode: ThemeMode.dark,
            ),
          );
          settingsRepository.mockSetThemeMode();
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.switchThemeMode();
        },
        expect: () => [
          const Settings(
            themeMode: ThemeMode.dark,
          ),
        ],
        verify: (_) => verify(
          () => settingsRepository.setThemeMode(ThemeMode.light),
        ).called(1),
      );
    },
  );
}
