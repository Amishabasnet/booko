import 'package:booko/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:booko/screens/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
