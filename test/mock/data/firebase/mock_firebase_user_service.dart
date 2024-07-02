import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/user_dto.dart';
import 'package:motorbike_navigator/data/firebase/firebase_user_service.dart';

class MockFirebaseUserService extends Mock implements FirebaseUserService {
  MockFirebaseUserService() {
    registerFallbackValue(ThemeModeDto.light);
  }

  void mockFetchUserById({
    UserDto? expectedUserDto,
  }) {
    when(
      () => fetchUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Future.value(expectedUserDto));
  }

  void mockAddUser({
    UserDto? expectedAddedUserDto,
  }) {
    when(
      () => addUser(
        userId: any(named: 'userId'),
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer((_) => Future.value(expectedAddedUserDto));
  }

  void mockUpdateUserThemeMode({
    UserDto? expectedUpdatedUserDto,
  }) {
    when(
      () => updateUserThemeMode(
        userId: any(named: 'userId'),
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer((_) => Future.value(expectedUpdatedUserDto));
  }
}
