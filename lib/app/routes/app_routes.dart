import 'package:booko/features/auth/presentation/pages/login_screen.dart';
import 'package:booko/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppRoutes {
  // Prevent instantiation
  AppRoutes._();

  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';

  static void pushReplacement(
    BuildContext context,
    DashboardHome dashboardHome,
  ) {}

  static void pushAndRemoveUntil(
    BuildContext context,
    LoginScreen loginScreen,
  ) {}
}
