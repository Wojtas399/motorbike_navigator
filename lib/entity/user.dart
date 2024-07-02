import 'entity.dart';

class User extends Entity {
  final ThemeMode themeMode;

  const User({
    required super.id,
    required this.themeMode,
  });

  @override
  List<Object?> get props => [
        id,
        themeMode,
      ];
}

enum ThemeMode { light, dark, system }
