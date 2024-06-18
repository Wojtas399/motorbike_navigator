import 'package:flutter/material.dart';

import '../../component/gap.dart';
import 'route_form_places_selection.dart';

class RouteFormScreen extends StatelessWidget {
  const RouteFormScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GapVertical24(),
              RouteFormPlacesSelection(),
            ],
          ),
        ),
      );
}
