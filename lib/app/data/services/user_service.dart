import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'dart:io';
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
    File? photoFile,
  }) async {
    try {
      dynamic requestData;
      
      print('=== REGISTER USER REQUEST ===');
      print('Email: $email');
      print('Username: $username');
      print('Password: ${password.isNotEmpty ? '***' : 'EMPTY'}');
      print('Role: $role');
      print('DepartmentId: $departmentId');
      print('Has Photo: ${photoFile != null}');
      
      if (photoFile != null) {
        // Use FormData for multipart request
        requestData = FormData.fromMap({
          'email': email,
          'username': username,
          'password': password,
          'role': role,
          if (departmentId != null) 'department_id': departmentId,
          'photo_profile': await MultipartFile.fromFile(
            photoFile.path,
            filename: photoFile.path.split('/').last,
          ),
        });
        print('Request type: FormData (multipart)');
      } else {
        // Use regular JSON data
        requestData = {
          'email': email,
          'username': username,
          'password': password,
          'role': role,
          if (departmentId != null) 'department_id': departmentId,
        };
        print('Request type: JSON');
        print('Request data: $requestData');
      }

      final response = await _apiProvider.post(
        '/users/register',
        data: requestData,
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

  /// Update user profile
  /// PUT /users/:id
  Future<UserModel> updateUser({
    required int userId,
    required String email,
    required String username,
    required String role,
    int? departmentId,
    String? phone,
    File? photoFile,
  }) async {
    try {
      dynamic requestData;

      if (photoFile != null) {
        // Use FormData for multipart request
        requestData = FormData.fromMap({
          'email': email,
          'username': username,
          'role': role,
          if (departmentId != null) 'department_id': departmentId,
          if (phone != null) 'phone': phone,
          'photo_profile': await MultipartFile.fromFile(
            photoFile.path,
            filename: photoFile.path.split('/').last,
          ),
        });
      } else {
        // Use regular JSON data
        requestData = {
          'email': email,
          'username': username,
          'role': role,
          if (departmentId != null) 'department_id': departmentId,
          if (phone != null) 'phone': phone,
        };
      }

      final response = await _apiProvider.put(
        '/users/$userId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return UserModel.fromJson(responseData['data']);
        }

        throw responseData['message'] ?? 'Failed to update user';
      }

      throw 'Failed to update user: ${response.statusCode}';
    } on DioException catch (e) {
      print('=== UPDATE USER API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');

      String errorMessage = 'Failed to update user';

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

  /// Change user password
  /// PUT /users/:id/password
  Future<void> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiProvider.put(
        '/users/$userId/password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] != true) {
          throw responseData['message'] ?? 'Failed to change password';
        }

        return; // Success
      }

      throw 'Failed to change password: ${response.statusCode}';
    } on DioException catch (e) {
      print('=== CHANGE PASSWORD API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');

      String errorMessage = 'Failed to change password';

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

  /// Delete user
  /// DELETE /users/:id
  Future<void> deleteUser(int userId) async {
    try {
      final response = await _apiProvider.delete('/users/$userId');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] != true) {
          throw responseData['message'] ?? 'Failed to delete user';
        }

        return; // Success
      }

      throw 'Failed to delete user: ${response.statusCode}';
    } on DioException catch (e) {
      print('=== DELETE USER API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');

      String errorMessage = 'Failed to delete user';

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
