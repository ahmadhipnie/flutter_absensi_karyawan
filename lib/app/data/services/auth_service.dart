import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/login_response_model.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class AuthService extends GetxService {
  final ApiProvider _apiProvider = ApiProvider();

  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<UserModel>();
  String? _token;

  bool get isLoggedIn => _isLoggedIn.value;
  UserModel? get currentUser => _currentUser.value;
  String? get token => _token;

  Future<AuthService> init() async {
    // Check saved session from secure storage
    // TODO: Implement secure storage for token persistence
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
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(response.data);

        if (loginResponse.success && loginResponse.data != null) {
          _currentUser.value = loginResponse.data;
          _isLoggedIn.value = true;

          // TODO: Save token to secure storage if API returns token
          // if (loginResponse.data?.token != null) {
          //   _token = loginResponse.data!.token;
          //   await secureStorage.write(
          //     key: 'auth_token',
          //     value: _token,
          //   );
          // }

          return loginResponse;
        }

        // Login failed but got response - return response so controller can handle message
        return loginResponse;
      }

      return null;
    } on DioException catch (e) {
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
        errorMessage = 'No internet connection';
      }

      throw errorMessage;
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
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

      // TODO: Clear secure storage
      // await secureStorage.delete(key: 'auth_token');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
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
