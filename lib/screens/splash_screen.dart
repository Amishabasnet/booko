import 'package:booko/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Cinematic dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or movie ticket icon
            Image.asset(
              'assets/booko-logo.jpg', // Replace with your ticket/logo image
              width: 120,
              height: 120,
            ),
            SizedBox(height: 20),
            // App name
            Text(
              'Booko',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent, // Vibrant color for cinema feel
              ),
            ),
            SizedBox(height: 10),
            // Optional tagline
            Text(
              'Your ultimate movie ticketing app',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
