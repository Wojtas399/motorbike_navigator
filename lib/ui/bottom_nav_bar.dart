import 'package:flutter/material.dart';

import 'extensions/context_extensions.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedPageIndex;
  final Function(int) onPageSelected;

  const BottomNavBar({
    super.key,
    required this.selectedPageIndex,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: onPageSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map),
            label: context.str.map,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark),
            label: context.str.saved,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: context.str.settings,
          ),
        ],
      );
}
