import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/user/user_repository.dart';
import 'package:motorbike_navigator/entity/user.dart';

class MockUserRepository extends Mock implements UserRepository {
  MockUserRepository() {
    registerFallbackValue(ThemeMode.light);
  }

  void mockGetUserById({
    User? expectedUser,
  }) {
    when(
      () => getUserById(
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => Stream.value(expectedUser));
  }

  void mockAddUser() {
    when(
      () => addUser(
        userId: any(named: 'userId'),
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateUserThemeMode() {
    when(
      () => updateUserThemeMode(
        userId: any(named: 'userId'),
        themeMode: any(named: 'themeMode'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
