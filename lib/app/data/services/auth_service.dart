import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class AuthService extends GetxService {
  late final ApiProvider _apiProvider;

  // Singleton instance
  static AuthService? _instance;
  static AuthService get instance => _instance!;

  // Get apiProvider for external access
  ApiProvider get apiProvider => _apiProvider;

  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  String? _token;

  // Keys for shared preferences
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  String? get token => _token;

  Future<AuthService> init() async {
    // Get ApiProvider from GetX
    _apiProvider = Get.find<ApiProvider>();

    // Set singleton instance
    _instance = this;

    // Load saved session from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString(_tokenKey);
    final savedUserJson = prefs.getString(_userKey);

    if (savedToken != null) {
      _token = savedToken;
      _isLoggedIn.value = true;

      // Parse user from JSON if available
      if (savedUserJson != null) {
        try {
          _currentUser.value = UserModel.fromJson(jsonDecode(savedUserJson));
        } catch (_) {
          // If parsing fails, clear invalid user data
          _currentUser.value = null;
        }
      }

      // Update API provider with token
      _apiProvider.setAuthToken(savedToken);
    }

    return this;
  }

  /// Login with email and password
  /// Returns LoginResponseModel if successful, null if failed
  /// Throws exception with error message - Controller should handle UI feedback
  Future<LoginResponseModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiProvider.post(
        '/users/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        if (loginResponse.success && loginResponse.data != null) {
          _currentUser.value = loginResponse.data;
          _isLoggedIn.value = true;

          // Save token
          if (loginResponse.token != null) {
            _token = loginResponse.token;
            _apiProvider.setAuthToken(loginResponse.token!);
            await _saveSession(loginResponse.token!);
          }

          return loginResponse;
        }

        // Login failed but got response - return response so controller can handle message
        return loginResponse;
      }

      return null;
    } on DioException catch (e) {
      // Debug print
      print('=== DIO ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      print('Error: ${e.error}');

      // Re-throw with message for controller to handle
      String errorMessage = 'Login failed';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        } else {
          errorMessage = 'Error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your internet.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error. Check your internet.';
      }

      throw errorMessage;
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  /// Save session to shared preferences
  Future<void> _saveSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    // Save user data as JSON
    if (_currentUser.value != null) {
      await prefs.setString(_userKey, jsonEncode(_currentUser.value!.toJson()));
    }
  }

  /// Clear session from shared preferences
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // TODO: Call API to invalidate token if needed
      // await _apiProvider.post('/users/logout');

      // Clear local data
      _currentUser.value = null;
      _isLoggedIn.value = false;
      _token = null;

      // Clear API provider token
      _apiProvider.clearAuthToken();

      // Clear shared preferences
      await _clearSession();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  /// Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate password strength
  bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
