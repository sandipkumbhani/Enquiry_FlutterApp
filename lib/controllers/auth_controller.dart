import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_config.dart';
import '../models/auth_models.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Auth Controller - Manages authentication state and operations
class AuthController extends GetxController {
  final apiService = Get.find<ApiService>();

  /// Reactive Variables
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUser = Rx<User?>(null);
  var currentProjectId = Rx<String?>(null);
  var errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  /// Check if user was previously logged in
  void _checkLoginStatus() {
    final token = StorageService.getToken();
    final projectId = StorageService.getProjectId();
    final userData = StorageService.getUserData();

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      currentProjectId.value = projectId;
      
      if (userData != null) {
        currentUser.value = User(
          id: userData['id'] ?? '',
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          phone: userData['phone'] ?? '',
          profileImage: userData['profileImage'],
          role: userData['role'] ?? 'user',
        );
      }
    }
  }

  /// Login Function
  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // Prepare login request
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      // Make API call
      final response = await apiService.post(
        AppConfig.loginEndpoint,
        data: loginRequest.toJson(),
      );

      if (response['success']) {
        final loginResponse = LoginResponse.fromJson(response['data']);

        if (loginResponse.success && loginResponse.data != null) {
          // Save data globally
          await _saveLoginData(loginResponse.data!, rememberMe);

          isLoggedIn.value = true;
          errorMessage.value = null;

          Get.offAllNamed('/dashboard');
          Get.snackbar('Success', 'Login successful',
              backgroundColor: const Color(0xff4CAF50),
              colorText: const Color(0xffffffff),
              duration: const Duration(seconds: 2));

          return true;
        } else {
          errorMessage.value = loginResponse.message;
          return false;
        }
      } else {
        errorMessage.value = response['message'] ?? 'Login failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Save login data globally
  Future<void> _saveLoginData(AuthData authData, bool rememberMe) async {
    // Save token
    await StorageService.setToken(authData.token);

    // Save project ID globally
    //await StorageService.setProjectId(authData.projectId);

    // Save user data
    //await StorageService.setUserData(authData.user.toJson());

    // Save remember me preference
    await StorageService.setRememberMe(rememberMe);

    // Update controller state
    // currentUser.value = authData.user;
    // currentProjectId.value = authData.projectId;

    print('🔐 Auth Data Saved:');
    print('   - Token: ${authData.token.substring(0, 20)}...');    
  }

  /// Logout Function
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Call logout API (optional)
      await apiService.post(AppConfig.logoutEndpoint);

      // Clear all stored data
      await StorageService.clearAll();

      // Reset controller state
      isLoggedIn.value = false;
      currentUser.value = null;
      currentProjectId.value = null;
      errorMessage.value = null;

      // Navigate to login
      Get.offAllNamed('/login');

      Get.snackbar('Success', 'Logged out successfully',
          backgroundColor: const Color(0xff4CAF50),
          colorText: const Color(0xffffffff),
          duration: const Duration(seconds: 2));
    } catch (e) {
      print('Logout error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get current token
  String? getToken() => StorageService.getToken();

  /// Get current project ID
  String? getProjectId() => StorageService.getProjectId();

  /// Get current user name
  String? getUserName() => currentUser.value?.name;

  /// Get current user email
  String? getUserEmail() => currentUser.value?.email;

  /// Refresh user data from server
  Future<void> refreshUserData() async {
    try {
      // This is optional - implement based on your API
      // final response = await apiService.get(AppConfig.userProfileEndpoint);
      // if (response['success']) {
      //   // Update user data
      // }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }
}
