import 'package:flutter/material.dart';

import 'package:booko/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:booko/features/offers/presentation/offers_screen.dart';
import 'package:booko/features/profile/presentation/pages/profile_screen.dart';
import 'package:booko/features/search/presentation/pages/search_screen.dart'
    as search_feature;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // ✅ One source of truth for tabs
  late final List<_TabItem> _tabs = [
    _TabItem(
      screen: const DashboardHome(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
    ),
    _TabItem(
      screen: const search_feature.SearchScreen(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ),
    _TabItem(
      screen: const OfferScreen(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.local_offer),
        label: 'Offers',
      ),
    ),
    _TabItem(
      screen: const ProfileScreen(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    final screens = _tabs.map((t) => t.screen).toList();
    final items = _tabs.map((t) => t.item).toList();

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff003366),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        iconSize: isSmallScreen ? 20 : 24,
        selectedFontSize: isSmallScreen ? 10 : 12,
        unselectedFontSize: isSmallScreen ? 9 : 11,
        items: items,
      ),
    );
  }
}

class _TabItem {
  final Widget screen;
  final BottomNavigationBarItem item;

  _TabItem({required this.screen, required this.item});
}
