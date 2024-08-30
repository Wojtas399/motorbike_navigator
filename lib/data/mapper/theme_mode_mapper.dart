import 'package:injectable/injectable.dart';

import '../../entity/settings.dart';
import '../local_db/dto/theme_mode_dto.dart';

@injectable
class ThemeModeMapper {
  ThemeMode mapFromDto(ThemeModeDto dto) => switch (dto.val) {
        ThemeModeDtoVal.light => ThemeMode.light,
        ThemeModeDtoVal.dark => ThemeMode.dark,
      };

  ThemeModeDto mapToDto(ThemeMode themeMode) => ThemeModeDto(
        switch (themeMode) {
          ThemeMode.light => ThemeModeDtoVal.light,
          ThemeMode.dark => ThemeModeDtoVal.dark,
        },
      );
}
