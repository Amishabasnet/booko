import 'package:flutter/material.dart';

import 'package:booko/screens/dashboard_screen.dart';
import 'package:booko/screens/dashboard/search_screen.dart';
import 'package:booko/screens/dashboard/offers_screen.dart';
import 'package:booko/screens/dashboard/profile_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booko"),
        backgroundColor: Colors.blueGrey,
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: "Offers",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
