import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart' as getx;
import '../../core/config/app_config.dart';

class ApiProvider extends getx.GetxService {
  late final Dio _dio;
  String? _authToken;

  // Singleton pattern using GetX
  static ApiProvider get instance {
    if (!getx.Get.isRegistered<ApiProvider>()) {
      getx.Get.put(ApiProvider._internal(), permanent: true);
    }
    return getx.Get.find<ApiProvider>();
  }

  // Private constructor
  ApiProvider._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          // Don't set Content-Type here - let Dio handle it based on request data
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'TalentaAttendance/1.0.0 (Flutter)',
        },
      ),
    );

    // Add interceptor for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          error: true,
        ),
      );
    }

    // Add interceptor to attach auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Attach auth token if available
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            // TODO: Trigger logout or refresh token
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data, // Changed from Map<String, dynamic>? to support FormData
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      // Auto-detect content type based on data
      Options finalOptions = options ?? Options();
      
      // Set JSON content-type for Map data, let Dio handle FormData automatically
      if (data is Map && finalOptions.contentType == null) {
        finalOptions = finalOptions.copyWith(
          contentType: 'application/json',
        );
      }
      
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: finalOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data, // Changed from Map<String, dynamic>? to support FormData
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      // Auto-detect content type based on data
      Options finalOptions = options ?? Options();
      
      // Set JSON content-type for Map data, let Dio handle FormData automatically
      if (data is Map && finalOptions.contentType == null) {
        finalOptions = finalOptions.copyWith(
          contentType: 'application/json',
        );
      }
      
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: finalOptions,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data, // Changed from Map<String, dynamic>? for consistency
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}
