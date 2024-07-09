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
  final ThemeModeMapper _themeModeMapper;
  final UserMapper _userMapper;

  UserRepositoryImpl(
    this._dbUserService,
    this._themeModeMapper,
    this._userMapper,
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
      themeMode: _themeModeMapper.mapToDto(themeMode),
    );
    if (addedUserDto == null) throw "Added user's data not found";
    final User addedUser = _userMapper.mapFromDto(addedUserDto);
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
      themeMode: _themeModeMapper.mapToDto(themeMode),
    );
    if (updatedUserDto == null) throw "Updated user's data not found";
    user = _userMapper.mapFromDto(updatedUserDto);
    updateEntity(user);
  }

  Future<User?> _fetchUserFromDb(String userId) async {
    final UserDto? userDto = await _dbUserService.fetchUserById(userId: userId);
    if (userDto == null) return null;
    final User user = _userMapper.mapFromDto(userDto);
    addEntity(user);
    return user;
  }

  Future<User?> _findExistingUserInRepoState(String userId) async {
    final List<User> existingUsers = await repositoryState$.first;
    return existingUsers.firstWhereOrNull((User user) => user.id == userId);
  }
}
