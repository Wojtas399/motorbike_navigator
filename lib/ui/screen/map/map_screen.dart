import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'map_content.dart';

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => const MapContent();
}
