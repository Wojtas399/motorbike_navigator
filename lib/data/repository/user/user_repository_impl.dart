import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/user.dart';
import '../../dto/user_dto.dart';
import '../../firebase/firebase_user_service.dart';
import '../../mapper/theme_mode_mapper.dart';
import '../../mapper/user_mapper.dart';
import '../repository.dart';
import 'user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends Repository<User> implements UserRepository {
  final FirebaseUserService _dbUserService;

  UserRepositoryImpl(
    this._dbUserService,
  );

  @override
  Stream<User?> getUserById({required String userId}) async* {
    await for (final users in repositoryState$) {
      User? user = users.firstWhereOrNull((user) => user.id == userId);
      user ??= await _fetchUserFromDb(userId);
      yield user;
    }
  }

  @override
  Future<void> addUser({
    required String userId,
    required ThemeMode themeMode,
  }) async {
    final UserDto? addedUserDto = await _dbUserService.addUser(
      userId: userId,
      themeMode: mapThemeModeToDto(themeMode),
    );
    if (addedUserDto == null) throw "Added user's data not found";
    final User addedUser = mapUserFromDto(addedUserDto);
    addEntity(addedUser);
  }

  @override
  Future<void> updateUserThemeMode({
    required String userId,
    required ThemeMode themeMode,
  }) async {
    User? user = await _findExistingUserInRepoState(userId);
    if (user == null) return;
    final UserDto? updatedUserDto = await _dbUserService.updateUserThemeMode(
      userId: userId,
      themeMode: mapThemeModeToDto(themeMode),
    );
    if (updatedUserDto == null) throw "Updated user's data not found";
    user = mapUserFromDto(updatedUserDto);
    updateEntity(user);
  }

  Future<User?> _fetchUserFromDb(String userId) async {
    final UserDto? userDto = await _dbUserService.fetchUserById(userId: userId);
    if (userDto == null) return null;
    final User user = mapUserFromDto(userDto);
    addEntity(user);
    return user;
  }

  Future<User?> _findExistingUserInRepoState(String userId) async {
    final List<User> existingUsers = await repositoryState$.first;
    return existingUsers.firstWhereOrNull((User user) => user.id == userId);
  }
}
