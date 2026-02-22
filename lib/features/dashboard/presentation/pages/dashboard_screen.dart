import 'package:booko/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:booko/features/dashboard/presentation/pages/offers_screen.dart';
import 'package:booko/features/profile/presentation/pages/profile_screen.dart';
import 'package:booko/features/search/presentation/pages/search_screen.dart'
    as search_feature;
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardHome(),
    search_feature.SearchScreen(), // ✅ uses alias so no conflict
    OffersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        iconSize: isSmallScreen ? 20 : 24,
        selectedFontSize: isSmallScreen ? 10 : 12,
        unselectedFontSize: isSmallScreen ? 9 : 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
