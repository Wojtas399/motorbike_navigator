import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(
    this._authRepository,
  ) : super(const SignInState());

  Future<void> initialize() async {
    final Stream<String?> loggedUserId$ = _authRepository.loggedUserId$;
    await for (final loggedUserId in loggedUserId$) {
      emit(state.copyWith(
        status: loggedUserId != null
            ? SignInStateStatus.userIsAlreadySignedIn
            : SignInStateStatus.completed,
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(
      status: SignInStateStatus.loading,
    ));
    await _authRepository.signInWithGoogle();
  }
}
