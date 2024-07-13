import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

enum SignInStateStatus {
  loading,
  completed,
  userIsAlreadySignedIn,
}

extension SignInStateStatusExtensions on SignInStateStatus {
  bool get isUserAlreadySignedIn =>
      this == SignInStateStatus.userIsAlreadySignedIn;
}

@freezed
class SignInState with _$SignInState {
  const SignInState._();

  const factory SignInState({
    @Default(SignInStateStatus.loading) SignInStateStatus status,
  }) = _SignInState;
}
