import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bindings/app_binding.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';

/// App Routes
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String menu = '/menu';
  static const String enquiries = '/enquiries';
  static const String projects = '/projects';
  static const String reports = '/reports';
  static const String settings = '/settings';
}

/// App Pages
class AppPages {
  static final pages = [
    // Splash Screen
    GetPage(
      name: AppRoutes.splash,
      page: () => const Scaffold(body: Center(child: Text('Real Estate CRM'))),
      binding: GlobalBinding(),
    ),

    // Login Screen
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),

    // Dashboard Screen
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),

    // Menu Screen
    GetPage(
      name: AppRoutes.menu,
      page: () => const Scaffold(body: Center(child: Text('Menu'))),
    ),

    // Enquiries Screen
    GetPage(
      name: AppRoutes.enquiries,
      page: () => const Scaffold(body: Center(child: Text('Enquiries'))),
    ),

    // Projects Screen
    GetPage(
      name: AppRoutes.projects,
      page: () => const Scaffold(body: Center(child: Text('Projects'))),
    ),

    // Reports Screen
    GetPage(
      name: AppRoutes.reports,
      page: () => const Scaffold(body: Center(child: Text('Reports'))),
    ),

    // Settings Screen
    GetPage(
      name: AppRoutes.settings,
      page: () => const Scaffold(body: Center(child: Text('Settings'))),
    ),
  ];
}
