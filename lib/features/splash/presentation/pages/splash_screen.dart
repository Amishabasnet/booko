import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/onboarding/presentation/pages/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      final userSessionService = ref.read(UserSessionServiceProvider);
      final isLoggedIn = userSessionService.isUserLoggedIn();

      if (isLoggedIn) {
        // ✅ If logged in -> go to your home/dashboard screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          // TODO: replace with DashboardScreen()
        );
      } else {
        // ✅ If not logged in -> go to onboarding/login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          // TODO: replace with LoginScreen()
        );
      }
    } catch (_) {
      // ✅ If provider fails for any reason, do not crash app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/movie_ticket.png',
              width: 240,
              height: 120,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
