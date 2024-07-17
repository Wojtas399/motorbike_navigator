import 'package:flutter/material.dart';

class StartRouteIcon extends StatelessWidget {
  const StartRouteIcon({super.key});

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(0, -8),
        child: const Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
      );
}
