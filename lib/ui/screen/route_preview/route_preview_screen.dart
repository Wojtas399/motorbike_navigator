import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RoutePreviewScreen extends StatelessWidget {
  const RoutePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route preview'),
      ),
    );
  }
}
