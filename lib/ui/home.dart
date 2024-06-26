import 'package:flutter/material.dart';

import 'screen/map/map_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: MapScreen(),
      );
}
