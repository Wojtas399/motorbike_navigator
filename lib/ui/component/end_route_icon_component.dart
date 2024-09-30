import 'package:flutter/material.dart';

class EndRouteIcon extends StatelessWidget {
  const EndRouteIcon({super.key});

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(4, -8),
        child: const Icon(
          Icons.flag,
          color: Colors.red,
        ),
      );
}
