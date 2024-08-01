import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repository/auth/auth_repository.dart';
import '../../data/repository/user/user_repository.dart';
import '../../entity/user.dart';
import '../../env.dart';

@injectable
class MapTileUrlProvider extends Cubit<String?> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<ThemeMode?>? _themeModeListener;

  MapTileUrlProvider(
    this._authRepository,
    this._userRepository,
  ) : super(null);

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

  Stream<ThemeMode?> _getThemeMode() => _authRepository.loggedUserId$
      .whereNotNull()
      .switchMap(
        (String loggedUserId) =>
            _userRepository.getUserById(userId: loggedUserId),
      )
      .map((User? loggedUser) => loggedUser?.themeMode);
}
