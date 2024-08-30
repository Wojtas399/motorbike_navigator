import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/settings.dart';
import 'package:motorbike_navigator/env.dart';
import 'package:motorbike_navigator/ui/provider/map_tile_url_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../mock/data/repository/mock_settings_repository.dart';

void main() {
  final settingsRepository = MockSettingsRepository();
  MapTileUrlProvider createProvider() => MapTileUrlProvider(settingsRepository);

  tearDown(() {
    reset(settingsRepository);
  });

  group(
    'initialize, ',
    () {
      final settings$ = BehaviorSubject<Settings?>.seeded(null);

      blocTest(
        'should listen to theme mode from SettingsRepository and should update '
        'tile url based on it',
        build: () => createProvider(),
        setUp: () => when(
          settingsRepository.getSettings,
        ).thenAnswer((_) => settings$.stream),
        act: (cubit) {
          cubit.initialize();
          settings$.add(
            const Settings(
              themeMode: ThemeMode.light,
            ),
          );
          settings$.add(
            const Settings(
              themeMode: ThemeMode.dark,
            ),
          );
        },
        expect: () => [
          Env.mapboxTemplateUrl,
          Env.mapboxTemplateUrlDark,
        ],
      );
    },
  );
}
