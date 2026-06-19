import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_config.dart';
import 'storage_service.dart';

/// Interceptor for handling API requests with token
class ApiInterceptor extends dio.Interceptor {
  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    // Add auth token to all requests
    final token = StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Set common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    
    print('📤 API Request: ${options.method} ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    print('📥 API Response: ${response.statusCode} ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    print('❌ API Error: ${err.message} | Status: ${err.response?.statusCode}');
    
    // Handle 401 - Unauthorized (Token expired)
    if (err.response?.statusCode == 401) {
      print('🔐 Token expired - Logging out user');
      _handleUnauthorized();
    }
    
    super.onError(err, handler);
  }

  void _handleUnauthorized() {
    // Clear stored data and redirect to login
    StorageService.clearAll();
    Get.offAllNamed('/login');
  }
}

/// API Service - Handles all HTTP requests
class ApiService extends GetxService {
  late dio.Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(seconds: AppConfig.connectTimeout),
        receiveTimeout: Duration(seconds: AppConfig.receiveTimeout),
        sendTimeout: Duration(seconds: AppConfig.sendTimeout),
        contentType: 'application/json',
        responseType: dio.ResponseType.json,
      ),
    );

    // Add interceptor
    _dio.interceptors.add(ApiInterceptor());
  }

  /// Generic GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool showError = true,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on dio.DioException catch (e) {
      return _handleError(e, showError);
    }
  }

  /// Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    bool showError = true,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } on dio.DioException catch (e) {
      return _handleError(e, showError);
    }
  }

  /// Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    bool showError = true,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      return _handleResponse(response);
    } on dio.DioException catch (e) {
      return _handleError(e, showError);
    }
  }

  /// Generic DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool showError = true,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } on dio.DioException catch (e) {
      return _handleError(e, showError);
    }
  }

  /// Handle successful response
  Map<String, dynamic> _handleResponse(dio.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      };
    }
    return {
      'success': false,
      'message': 'Unexpected status code: ${response.statusCode}',
      'statusCode': response.statusCode,
    };
  }

  /// Handle error response
  Map<String, dynamic> _handleError(dio.DioException error, bool showError) {
    String message = 'An error occurred';
    
    if (error.type == dio.DioExceptionType.connectionTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (error.type == dio.DioExceptionType.receiveTimeout) {
      message = 'Request timeout. Please try again.';
    } else if (error.type == dio.DioExceptionType.badResponse) {
      message = error.response?.data['message'] ?? 'Server error';
    } else if (error.type == dio.DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    if (showError) {
      Get.snackbar(
        'Error',
        message,
        backgroundColor: const Color(0xffC72C48),
        colorText: const Color(0xffffffff),
        duration: const Duration(seconds: 3),
      );
    }

    return {
      'success': false,
      'message': message,
      'error': error.message,
      'statusCode': error.response?.statusCode ?? 0,
    };
  }
}
