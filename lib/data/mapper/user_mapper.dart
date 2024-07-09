import 'package:injectable/injectable.dart';

import '../../entity/user.dart';
import '../dto/user_dto.dart';
import 'mapper.dart';
import 'theme_mode_mapper.dart';

@injectable
class UserMapper extends Mapper<User, UserDto> {
  final ThemeModeMapper _themeModeMapper;

  const UserMapper(this._themeModeMapper);

  @override
  User mapFromDto(UserDto dto) => User(
        id: dto.id,
        themeMode: _themeModeMapper.mapFromDto(dto.themeMode),
      );

  @override
  UserDto mapToDto(User object) => UserDto(
        id: object.id,
        themeMode: _themeModeMapper.mapToDto(object.themeMode),
      );
}
