import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/users_response_model.dart';
import '../models/register_user_response_model.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class UserService extends GetxService {
  // Use singleton ApiProvider
  ApiProvider get _apiProvider => ApiProvider.instance;

  /// Get all users
  /// Returns List<UserModel> if successful
  /// Throws exception with error message if failed
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiProvider.get('/users');

      if (response.statusCode == 200) {
        final usersResponse = UsersResponseModel.fromJson(response.data);

        if (usersResponse.success) {
          return usersResponse.data;
        }

        throw usersResponse.message;
      }

      throw 'Failed to load users: ${response.statusCode}';
    } on DioException catch (e) {
      // Debug print
      print('=== USER API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      print('Error: ${e.error}');

      // Re-throw with message
      String errorMessage = 'Failed to load users';

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

  /// Register new user
  /// Returns UserModel if successful
  /// Throws exception with error message if failed
  Future<UserModel> registerUser({
    required String email,
    required String username,
    required String password,
    required String role,
    int? departmentId,
  }) async {
    try {
      final response = await _apiProvider.post(
        '/users/register',
        data: {
          'email': email,
          'username': username,
          'password': password,
          'role': role,
          if (departmentId != null) 'department_id': departmentId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final registerResponse = RegisterUserResponseModel.fromJson(response.data);

        if (registerResponse.success) {
          return registerResponse.data;
        }

        throw registerResponse.message;
      }

      throw 'Failed to register user: ${response.statusCode}';
    } on DioException catch (e) {
      // Debug print
      print('=== REGISTER USER API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      print('Error: ${e.error}');

      // Re-throw with message
      String errorMessage = 'Failed to register user';

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
}
