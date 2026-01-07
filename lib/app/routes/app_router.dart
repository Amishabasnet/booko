import 'package:booko/app/routes/app_routes.dart';
import 'package:booko/features/auth/presentation/pages/login_screen.dart';
import 'package:booko/features/auth/presentation/pages/register_screen.dart';
import 'package:booko/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:booko/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

/// Application Router
///
/// Handles all navigation and route generation for the app.
/// Uses named routes for easy navigation management.
class AppRouter {
  // Prevent instantiation
  AppRouter._();

  /// Initial route when app starts
  static const String initialRoute = AppRoutes.splash;

  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);

      // Auth
      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);

      case AppRoutes.signup:
        return _buildRoute(const RegisterScreen(), settings);

      // Dashboard (NO AUTH GUARD)
      case AppRoutes.dashboard:
        return _buildRoute(const DashboardScreen(), settings);

      // Unknown route
      default:
        return _buildRoute(const _UnknownRoutePage(), settings);
    }
  }

  /// Build a MaterialPageRoute with consistent settings
  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  /// Named routes map (optional but useful)
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.signup: (_) => const RegisterScreen(),
    AppRoutes.dashboard: (_) => const DashboardScreen(),
  };
}

/// Fallback page for unknown routes
class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested page does not exist.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.dashboard,
                  (route) => false,
                );
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
