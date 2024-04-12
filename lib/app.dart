import 'package:flutter/material.dart';
import 'package:motorbike_navigator/ui/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motorbike navigator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const Home(),
    );
  }
}
