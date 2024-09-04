import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../config/app_router.dart';
import '../../../extensions/context_extensions.dart';

class MapDrawer extends StatelessWidget {
  const MapDrawer({super.key});

  void _navigateToSavedDrives(BuildContext context) {
    context.pushRoute(const SavedDrivesRoute());
  }

  void _navigateToStats(BuildContext context) {
    context.pushRoute(const StatsRoute());
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                ListTile(
                  title: Text(context.str.savedDrivesScreenTitle),
                  leading: const Icon(Icons.bookmark),
                  onTap: () => _navigateToSavedDrives(context),
                ),
                ListTile(
                  title: Text(context.str.statsScreenTitle),
                  leading: const Icon(Icons.bar_chart_outlined),
                  onTap: () => _navigateToStats(context),
                ),
              ],
            ),
          ),
        ),
      );
}
