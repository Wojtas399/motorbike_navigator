import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../data/repository/user/user_repository.dart';
import '../../../entity/user.dart';
import 'logged_user_state.dart';

@injectable
class LoggedUserCubit extends Cubit<LoggedUserState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoggedUserCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const LoggedUserStateLoading());

  Future<void> initialize() async {
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId == null) {
      emit(const LoggedUserStateLoggedUserDoesNotExist());
      return;
    }
    final User? loggedUser =
        await _userRepository.getUserById(userId: loggedUserId).first;
    if (loggedUser == null) {
      await _userRepository.addUser(
        userId: loggedUserId,
        themeMode: ThemeMode.system,
      );
    }
    emit(const LoggedUserStateCompleted());
  }
}
