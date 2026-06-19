import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_config.dart';
import 'config/app_pages.dart';
import 'bindings/app_binding.dart';
import 'services/storage_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  await StorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xff1E3A8A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff1E3A8A),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff1E3A8A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff1E3A8A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Dark Theme (Optional)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xff3B82F6),
      ),

      // Global Binding for dependency injection
      initialBinding: GlobalBinding(),

      // GetX Pages/Routes
      getPages: AppPages.pages,

      // Initial route based on login status
      initialRoute: StorageService.isLoggedIn()
          ? AppRoutes.dashboard
          : AppRoutes.login,

      // Home screen
      home: StorageService.isLoggedIn()
          ? DashboardScreen()
          : const LoginScreen(),

      // Navigation observers for logging
      navigatorObservers: [GetObserver()],
    );
  }
}
