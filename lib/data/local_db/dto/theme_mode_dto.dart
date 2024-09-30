import 'package:equatable/equatable.dart';

class ThemeModeDto extends Equatable {
  final ThemeModeDtoVal val;

  const ThemeModeDto(this.val);

  factory ThemeModeDto.fromString(String val) => ThemeModeDto(
        ThemeModeDtoVal.values.byName(val),
      );

  @override
  List<Object?> get props => [val];

  @override
  String toString() => val.name;
}

enum ThemeModeDtoVal { light, dark }
