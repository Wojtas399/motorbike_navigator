import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SavedDrivesScreen extends StatelessWidget {
  const SavedDrivesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Zapisane przejazdy'),
        ),
      );
}
