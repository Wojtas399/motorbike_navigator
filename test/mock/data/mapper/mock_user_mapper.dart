import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/mapper/user_mapper.dart';
import 'package:motorbike_navigator/entity/user.dart';

class MockUserMapper extends Mock implements UserMapper {
  MockUserMapper() {
    registerFallbackValue(
      const UserDto(themeMode: ThemeModeDto.light),
    );
  }

  void mockMapFromDto({
    required User expectedUser,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedUser);
  }
}
