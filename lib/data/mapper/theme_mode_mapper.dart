import 'package:injectable/injectable.dart';

import '../../entity/user.dart';
import '../dto/user_dto.dart';
import 'mapper.dart';

@injectable
class ThemeModeMapper extends Mapper<ThemeMode, ThemeModeDto> {
  const ThemeModeMapper();

  @override
  ThemeMode mapFromDto(ThemeModeDto dto) => switch (dto) {
        ThemeModeDto.light => ThemeMode.light,
        ThemeModeDto.dark => ThemeMode.dark,
        ThemeModeDto.system => ThemeMode.system,
      };

  @override
  ThemeModeDto mapToDto(ThemeMode object) => switch (object) {
        ThemeMode.light => ThemeModeDto.light,
        ThemeMode.dark => ThemeModeDto.dark,
        ThemeMode.system => ThemeModeDto.system,
      };
}
