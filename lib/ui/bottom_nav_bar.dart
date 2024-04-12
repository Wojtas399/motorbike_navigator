import 'package:flutter/material.dart';

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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark),
            label: 'Zapisane',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Ustawienia',
          ),
        ],
      );
}
