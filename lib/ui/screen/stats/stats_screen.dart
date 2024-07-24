import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

@RoutePage()
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.str.statsScreenTitle),
        ),
      );
}
