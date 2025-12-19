import 'package:flutter/material.dart';

import 'package:booko/screens/dashboard_screen.dart';
import 'package:booko/screens/search_screen.dart';
import 'package:booko/screens/offers_screen.dart';
import 'package:booko/screens/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SearchScreen(),
    OffersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // Responsive settings
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1024;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: NavigationBar(
          height: isMobile ? 65 : 75,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          labelBehavior: isMobile
              ? NavigationDestinationLabelBehavior.alwaysShow
              : NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_offer_outlined),
              selectedIcon: Icon(Icons.local_offer),
              label: 'Offers',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
