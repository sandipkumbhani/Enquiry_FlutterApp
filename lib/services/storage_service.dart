import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';

/// Local Storage Service - Handles app-level persistent storage
class StorageService {
  static late GetStorage _storage;

  /// Initialize storage (call in main.dart before app start)
  static Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  // ============ Authentication ============

  /// Save authentication token
  static Future<void> setToken(String token) async {
    await _storage.write(AppConfig.authTokenKey, token);
  }

  /// Get authentication token
  static String? getToken() {
    return _storage.read<String>(AppConfig.authTokenKey);
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return getToken() != null && getToken()!.isNotEmpty;
  }

  // ============ Project Management ============

  /// Save global Project ID
  static Future<void> setProjectId(String projectId) async {
    await _storage.write(AppConfig.projectIdKey, projectId);
  }

  /// Get global Project ID
  static String? getProjectId() {
    return _storage.read<String>(AppConfig.projectIdKey);
  }

  // ============ User Data ============

  /// Save user data
  static Future<void> setUserData(Map<String, dynamic> userData) async {
    await _storage.write(AppConfig.userDataKey, userData);
  }

  /// Get user data
  static Map<String, dynamic>? getUserData() {
    return _storage.read<Map<String, dynamic>>(AppConfig.userDataKey);
  }

  /// Get user full name
  static String? getUserFullName() {
    final userData = getUserData();
    return userData?['fullName'] ?? userData?['name'];
  }

  /// Get user email
  static String? getUserEmail() {
    final userData = getUserData();
    return userData?['email'];
  }

  // ============ Remember Me ============

  /// Save remember me preference
  static Future<void> setRememberMe(bool value) async {
    await _storage.write(AppConfig.rememberMeKey, value);
  }

  /// Check if remember me is enabled
  static bool isRememberMeEnabled() {
    return _storage.read<bool>(AppConfig.rememberMeKey) ?? false;
  }

  // ============ General Storage ============

  /// Save any custom data
  static Future<void> setValue(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Get any custom data
  static T? getValue<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Remove specific key
  static Future<void> removeKey(String key) async {
    await _storage.remove(key);
  }

  /// Clear all stored data (Logout)
  static Future<void> clearAll() async {
    await _storage.erase();
  }

  /// Clear specific keys
  static Future<void> clearMultiple(List<String> keys) async {
    for (var key in keys) {
      await _storage.remove(key);
    }
  }

  /// Check if key exists
  static bool hasKey(String key) {
    return _storage.hasData(key);
  }

  /// Get all keys
  static List<String> getAllKeys() {
    return _storage.getKeys();
  }
}
