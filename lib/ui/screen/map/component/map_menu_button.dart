import 'package:flutter/material.dart';

class MapMenuButton extends StatelessWidget {
  const MapMenuButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        onPressed: Scaffold.of(context).openDrawer,
        icon: const Icon(Icons.menu),
      );
}
