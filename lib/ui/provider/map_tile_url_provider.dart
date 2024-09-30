import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/repository/settings/settings_repository.dart';
import '../../entity/settings.dart';
import '../../env.dart';

@injectable
class MapTileUrlProvider extends Cubit<String?> {
  final SettingsRepository _settingsRepository;

  MapTileUrlProvider(
    this._settingsRepository,
  ) : super(null);

  Future<void> initialize() async {
    final Stream<ThemeMode?> themeMode$ = _getThemeMode();
    await for (final themeMode in themeMode$) {
      _handleThemeModeChange(themeMode);
    }
  }

  void _handleThemeModeChange(ThemeMode? themeMode) {
    if (themeMode == null) return;
    final String mapTile = switch (themeMode) {
      ThemeMode.light => Env.mapboxTemplateUrl,
      ThemeMode.dark => Env.mapboxTemplateUrlDark,
    };
    emit(mapTile);
  }

  Stream<ThemeMode?> _getThemeMode() => _settingsRepository.getSettings().map(
        (Settings? settings) => settings?.themeMode,
      );
}
