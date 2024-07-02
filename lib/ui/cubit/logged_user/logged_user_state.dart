sealed class LoggedUserState {
  const LoggedUserState();
}

class LoggedUserStateLoading extends LoggedUserState {
  const LoggedUserStateLoading();
}

class LoggedUserStateCompleted extends LoggedUserState {
  const LoggedUserStateCompleted();
}

class LoggedUserStateLoggedUserDoesNotExist extends LoggedUserState {
  const LoggedUserStateLoggedUserDoesNotExist();
}
