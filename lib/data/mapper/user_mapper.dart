import '../../entity/user.dart';
import '../dto/user_dto.dart';
import 'theme_mode_mapper.dart';

User mapUserFromDto(UserDto userDto) => User(
      id: userDto.id,
      themeMode: mapThemeModeFromDto(userDto.themeMode),
    );

UserDto mapUserToDto(User user) => UserDto(
      id: user.id,
      themeMode: mapThemeModeToDto(user.themeMode),
    );
