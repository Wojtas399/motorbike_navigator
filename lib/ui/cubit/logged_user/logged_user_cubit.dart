import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../data/repository/user/user_repository.dart';
import '../../../entity/user.dart';
import 'logged_user_state.dart';

@injectable
class LoggedUserCubit extends Cubit<LoggedUserState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<_ListenedParams?>? _listener;

  LoggedUserCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const LoggedUserState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _authRepository.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            Stream.value(loggedUserId),
            _userRepository.getUserById(userId: loggedUserId),
            (String loggedUserId, User? loggedUserData) => _ListenedParams(
              loggedUserId: loggedUserId,
              loggedUserData: loggedUserData,
            ),
          ),
        )
        .listen(_handleListenedParams);
  }

  Future<void> changeThemeMode(ThemeMode newThemeMode) async {
    final LoggedUserState prevState = state;
    emit(state.copyWith(
      status: LoggedUserStateStatus.completed,
      themeMode: newThemeMode,
    ));
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId != null) {
      await _userRepository.updateUserThemeMode(
        userId: loggedUserId,
        themeMode: newThemeMode,
      );
    } else {
      emit(prevState);
    }
  }

  Future<void> _handleListenedParams(_ListenedParams params) async {
    if (params.loggedUserData == null) {
      await _userRepository.addUser(
        userId: params.loggedUserId,
        themeMode: ThemeMode.light,
      );
    }
    emit(state.copyWith(
      status: LoggedUserStateStatus.completed,
      themeMode: params.loggedUserData?.themeMode,
    ));
  }
}

class _ListenedParams extends Equatable {
  final String loggedUserId;
  final User? loggedUserData;

  const _ListenedParams({
    required this.loggedUserId,
    this.loggedUserData,
  });

  @override
  List<Object?> get props => [
        loggedUserId,
        loggedUserData,
      ];
}
