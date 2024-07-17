import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppTheme {
  final Color _primaryColor = Colors.teal;

  ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor),
      );

  ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
        ),
      );
}
