/// Global Configuration Constants
class AppConfig {
  /// API Base URLs - Change based on environment
  static const String baseUrl = 'https://setuapi.broadsytechnologies.com';  /// Change to your API URL
  static const String apiVersion = '/api';
  
  /// Complete API Endpoints
  static const String loginEndpoint = '$apiVersion/login';
  static const String dashboardEndpoint = '$apiVersion/dashboard';
  static const String menuEndpoint = '$apiVersion/menu';
  static const String enquiriesEndpoint = '$apiVersion/enquiries';
  static const String projectsEndpoint = '$apiVersion/projects';
  static const String logoutEndpoint = '$apiVersion/auth/logout';
  
  /// App Constants
  static const String appName = 'Real Estate CRM';
  static const String appVersion = '1.0.0';
  
  /// Local Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String projectIdKey = 'project_id';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String rememberMeKey = 'remember_me';
  
  /// Timeouts (in seconds)
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
}

/// Environment Configuration
enum AppEnvironment { development, staging, production }

class EnvironmentConfig {
  static const AppEnvironment environment = AppEnvironment.development;
  
  static String getBaseUrl() {
    switch (environment) {
      case AppEnvironment.development:
        return 'https://setuapi.broadsytechnologies.com';
      case AppEnvironment.staging:
        return 'https://setuapi.broadsytechnologies.com';
      case AppEnvironment.production:
        return 'https://setuapi.broadsytechnologies.com';
    }
  }
}
