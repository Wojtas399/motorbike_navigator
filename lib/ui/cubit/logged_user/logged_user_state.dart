import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/user.dart';

part 'logged_user_state.freezed.dart';

enum LoggedUserStateStatus { loading, completed }

extension LoggedUserStateStatusExtensions on LoggedUserStateStatus {
  bool get isLoading => this == LoggedUserStateStatus.loading;
}

@freezed
class LoggedUserState with _$LoggedUserState {
  const factory LoggedUserState({
    @Default(LoggedUserStateStatus.loading) LoggedUserStateStatus status,
    ThemeMode? themeMode,
  }) = _LoggedUserState;
}
