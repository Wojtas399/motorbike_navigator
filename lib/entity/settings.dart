import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final ThemeMode themeMode;

  const Settings({
    required this.themeMode,
  });

  @override
  List<Object?> get props => [themeMode];
}

enum ThemeMode { light, dark }
