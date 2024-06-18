import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';
import 'saved/saved_page.dart';
import 'screen/map/map_screen.dart';
import 'settings/settings_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Home> {
  int _selectedPageIndex = 0;
  final List<Widget> _pages = [
    const MapScreen(),
    const SavedPage(),
    const SettingsPage(),
  ];

  void _onPageSelected(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: BottomNavBar(
          selectedPageIndex: _selectedPageIndex,
          onPageSelected: _onPageSelected,
        ),
      );
}
