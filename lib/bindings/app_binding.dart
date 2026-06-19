import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/menu_controller.dart';
import '../services/api_service.dart';

/// Global Binding - Initialize all global dependencies
class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize API Service (Singleton)
    Get.put<ApiService>(ApiService());

    // Initialize Auth Controller (Singleton)
    Get.put<AuthController>(AuthController());

    // Initialize Menu Controller (Singleton)
    Get.put<MenuController>(MenuController());
  }
}

/// Dashboard Binding - Initialize dashboard-specific dependencies
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize Dashboard Controller
    Get.put<DashboardController>(DashboardController());
  }
}

/// Auth Binding - Initialize auth-specific dependencies
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Auth controller is already initialized globally
    // This can be used for screen-specific logic if needed
  }
}
