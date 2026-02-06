import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/departments_response_model.dart';
import '../models/department_model.dart';
import '../providers/api_provider.dart';

class DepartmentService extends GetxService {
  // Use singleton ApiProvider
  ApiProvider get _apiProvider => ApiProvider.instance;

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
}
