import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dto/theme_mode_dto.dart';

@injectable
class SettingsSharedPreferencesService {
  final String _themeModeId = 'theme_mode';

  Future<ThemeModeDto?> loadThemeMode() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final String? themeModeStr = sharedPrefs.getString(_themeModeId);
    return themeModeStr != null ? ThemeModeDto.fromString(themeModeStr) : null;
  }

  Future<void> setThemeMode(ThemeModeDto themeModeDto) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
      _themeModeId,
      themeModeDto.toString(),
    );
  }
}
