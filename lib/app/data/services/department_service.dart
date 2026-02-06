import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'dart:io';
import '../models/departments_response_model.dart';
import '../models/department_model.dart';
import '../models/department_task_model.dart';
import '../providers/api_provider.dart';

class DepartmentService extends GetxService {
  // Use singleton ApiProvider
  ApiProvider get _apiProvider => ApiProvider.instance;

  /// Get tasks for a department
  Future<List<DepartmentTaskModel>> getDepartmentTasks(int departmentId) async {
    try {
      final response = await _apiProvider.get('/tasks/department/$departmentId/assignments');

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'] ?? [];
          return data.map((json) => DepartmentTaskModel.fromJson(json)).toList();
        }
        throw responseData['message'] ?? 'Failed to load department tasks';
      }

      throw 'Failed to load department tasks: ${response.statusCode}';
    } on DioException catch (e) {
      print('=== DEPARTMENT TASKS API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');

      String errorMessage = 'Failed to load department tasks';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        } else {
          errorMessage = 'Error: ${e.response!.statusCode}';
        }
      }

      throw errorMessage;
    } catch (e) {
      throw 'An unexpected error occurred: ${e.toString()}';
    }
  }

  /// Get all departments
  /// Returns List<DepartmentModel> if successful
  /// Throws exception with error message if failed
  Future<List<DepartmentModel>> getDepartments() async {
    try {
      final response = await _apiProvider.get('/departments');

      if (response.statusCode == 200) {
        final departmentsResponse = DepartmentsResponseModel.fromJson(response.data);

        if (departmentsResponse.success) {
          return departmentsResponse.data;
        }

        throw 'Failed to load departments';
      }

      throw 'Failed to load departments: ${response.statusCode}';
    } on DioException catch (e) {
      // Debug print
      print('=== DEPARTMENT API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      print('Error: ${e.error}');

      // Re-throw with message
      String errorMessage = 'Failed to load departments';

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

  /// Create new department
  /// Returns DepartmentModel if successful
  /// Throws exception with error message if failed
  Future<DepartmentModel> createDepartment({
    required String name,
    required String description,
    File? photoFile,
  }) async {
    try {
      dynamic requestData;

      if (photoFile != null) {
        // Use FormData for multipart request
        requestData = FormData.fromMap({
          'departments_name': name,
          'description': description,
          'photo': await MultipartFile.fromFile(
            photoFile.path,
            filename: photoFile.path.split('/').last,
          ),
        });
      } else {
        // Use regular JSON data
        requestData = {
          'departments_name': name,
          'description': description,
        };
      }

      final response = await _apiProvider.post(
        '/departments',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true) {
          return DepartmentModel.fromJson(responseData['data']);
        }

        throw responseData['message'] ?? 'Failed to create department';
      }

      throw 'Failed to create department: ${response.statusCode}';
    } on DioException catch (e) {
      // Debug print
      print('=== CREATE DEPARTMENT API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');
      print('Error: ${e.error}');

      // Re-throw with message
      String errorMessage = 'Failed to create department';

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

  /// Update department
  /// PUT /departments/:id
  Future<DepartmentModel> updateDepartment({
    required int departmentId,
    required String name,
    required String description,
    File? photoFile,
  }) async {
    try {
      dynamic requestData;

      if (photoFile != null) {
        requestData = FormData.fromMap({
          'departments_name': name,
          'description': description,
          'photo': await MultipartFile.fromFile(
            photoFile.path,
            filename: photoFile.path.split('/').last,
          ),
        });
      } else {
        requestData = {
          'departments_name': name,
          'description': description,
        };
      }

      final response = await _apiProvider.put(
        '/departments/$departmentId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] == true) {
          return DepartmentModel.fromJson(responseData['data']);
        }

        throw responseData['message'] ?? 'Failed to update department';
      }

      throw 'Failed to update department: ${response.statusCode}';
    } on DioException catch (e) {
      print('=== UPDATE DEPARTMENT API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');

      String errorMessage = 'Failed to update department';

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

  /// Delete department
  /// DELETE /departments/:id
  Future<void> deleteDepartment(int departmentId) async {
    try {
      final response = await _apiProvider.delete('/departments/$departmentId');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['success'] != true) {
          throw responseData['message'] ?? 'Failed to delete department';
        }

        return;
      }

      throw 'Failed to delete department: ${response.statusCode}';
    } on DioException catch (e) {
      print('=== DELETE DEPARTMENT API ERROR ===');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response: ${e.response}');

      String errorMessage = 'Failed to delete department';

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
