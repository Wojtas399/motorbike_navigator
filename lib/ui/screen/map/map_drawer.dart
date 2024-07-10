import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../config/app_router.dart';
import '../../extensions/context_extensions.dart';

class MapDrawer extends StatelessWidget {
  const MapDrawer({super.key});

  void _navigateToSavedDrives(BuildContext context) {
    context.pushRoute(const SavedDrivesRoute());
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                ListTile(
                  title: Text(context.str.mapSavedDrives),
                  leading: const Icon(Icons.bookmark_outline),
                  onTap: () => _navigateToSavedDrives(context),
                ),
              ],
            ),
          ),
        ),
      );
}
