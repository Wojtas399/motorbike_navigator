import '../../../entity/user.dart';

abstract interface class UserRepository {
  Stream<User?> getUserById({required String userId});

  Future<void> addUser({
    required String userId,
    required ThemeMode themeMode,
  });

  Future<void> updateUserThemeMode({
    required String userId,
    required ThemeMode themeMode,
  });
}
