import 'package:get/get.dart';
import '../config/app_config.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'auth_controller.dart';

/// Menu Item Model
class MenuItem {
  final String id;
  final String title;
  final String icon;
  final String? route;
  final Function()? onTap;
  final List<MenuItem>? subItems;

  MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    this.route,
    this.onTap,
    this.subItems,
  });
}

/// Menu Controller - Manages menu items and navigation
class MenuController extends GetxController {
  final apiService = Get.find<ApiService>();

  /// Reactive Variables
  var isLoading = false.obs;
  var menuItems = Rx<List<MenuItem>?>(null);
  var errorMessage = Rx<String?>(null);
  var selectedMenuItem = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadMenuItems();
  }

  /// Load menu items from API
  Future<void> loadMenuItems() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Get project ID from global storage
      final projectId = StorageService.getProjectId();
      if (projectId == null) {
        errorMessage.value = 'Project ID not found. Please login again.';
        _setDefaultMenu();
        return;
      }

      // Make API call with project ID
      final response = await apiService.get(
        AppConfig.menuEndpoint,
        queryParameters: {'projectId': projectId},
      );

      if (response['success']) {
        // Parse menu items from response
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null && data['items'] != null) {
          final items = (data['items'] as List)
              .map((item) => _parseMenuItem(item))
              .toList();
          menuItems.value = items;
          print('✅ Menu items loaded successfully');
        } else {
          _setDefaultMenu();
        }
      } else {
        print('⚠️ Failed to load menu from API, using default menu');
        _setDefaultMenu();
      }
    } catch (e) {
      print('❌ Menu error: $e');
      _setDefaultMenu();
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse menu item from JSON
  MenuItem _parseMenuItem(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? 'home',
      route: json['route'],
    );
  }

  /// Set default menu items (fallback)
  void _setDefaultMenu() {
    menuItems.value = [
      MenuItem(
        id: '1',
        title: 'Dashboard',
        icon: 'home',
        route: '/dashboard',
      ),
      MenuItem(
        id: '2',
        title: 'Enquiries',
        icon: 'mail',
        route: '/enquiries',
      ),
      MenuItem(
        id: '3',
        title: 'Projects',
        icon: 'folder',
        route: '/projects',
      ),
      MenuItem(
        id: '4',
        title: 'Reports',
        icon: 'bar_chart',
        route: '/reports',
      ),
      MenuItem(
        id: '5',
        title: 'Settings',
        icon: 'settings',
        route: '/settings',
      ),
      MenuItem(
        id: '6',
        title: 'Logout',
        icon: 'logout',
        onTap: () => Get.find<AuthController>().logout(),
      ),
    ];
  }

  /// Select menu item
  void selectMenuItem(String itemId) {
    selectedMenuItem.value = itemId;
  }

  /// Get selected menu item
  MenuItem? getSelectedMenuItem() {
    if (selectedMenuItem.value == null) return null;
    return menuItems.value?.firstWhereOrNull(
      (item) => item.id == selectedMenuItem.value,
    );
  }

  /// Navigate to menu item
  void navigateToMenuItem(MenuItem item) {
    selectMenuItem(item.id);
    if (item.route != null) {
      Get.toNamed(item.route!);
    } else if (item.onTap != null) {
      item.onTap!();
    }
  }

  /// Refresh menu items
  Future<void> refreshMenu() async {
    await loadMenuItems();
  }
}
