import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../entity/settings.dart';
import '../../env.dart';

@injectable
class MapTileUrlProvider extends Cubit<String?> {
  StreamSubscription<ThemeMode?>? _themeModeListener;

  MapTileUrlProvider() : super(null);

  @override
  Future<void> close() {
    _themeModeListener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _themeModeListener = _getThemeMode().listen(_handleThemeModeChange);
  }

  void _handleThemeModeChange(ThemeMode? themeMode) {
    final String? mapTile = switch (themeMode) {
      null => null,
      ThemeMode.light => Env.mapboxTemplateUrl,
      ThemeMode.dark => Env.mapboxTemplateUrlDark,
    };
    emit(mapTile);
  }

  Stream<ThemeMode?> _getThemeMode() => Stream.value(ThemeMode.light); //TODO
}
