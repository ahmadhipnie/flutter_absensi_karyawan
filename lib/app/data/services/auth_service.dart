import 'package:get/get.dart';

class AuthService extends GetxService {
  final _isLoggedIn = false.obs;
  final _currentUser = Rxn<Map<String, dynamic>>();

  bool get isLoggedIn => _isLoggedIn.value;
  Map<String, dynamic>? get currentUser => _currentUser.value;

  Future<AuthService> init() async {
    // Initialize service, check saved session, etc.
    return this;
  }

  /// Login with email and password
  /// Returns true if login successful, false otherwise
  Future<bool> login({required String email, required String password}) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual API call
      // Example: final response = await apiClient.post('/auth/login', {
      //   'email': email,
      //   'password': password,
      // });

      // Mock validation - replace with actual API response
      if (email.isNotEmpty && password.length >= 6) {
        _currentUser.value = {'id': '1', 'email': email, 'name': 'User Name'};
        _isLoggedIn.value = true;

        // TODO: Save token to secure storage
        // await secureStorage.write(key: 'auth_token', value: token);

        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // TODO: Call API to invalidate token
      // await apiClient.post('/auth/logout');

      // Clear local data
      _currentUser.value = null;
      _isLoggedIn.value = false;

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
