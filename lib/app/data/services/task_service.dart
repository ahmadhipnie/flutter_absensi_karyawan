import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../models/task_model.dart';
import '../providers/api_provider.dart';

class TaskService extends GetxService {
  late final ApiProvider _apiProvider;

  @override
  void onInit() {
    super.onInit();
    // Get shared ApiProvider instance from GetX
    _apiProvider = Get.find<ApiProvider>();
  }

  final _myAssignedTasks = <TaskModel>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();

  List<TaskModel> get myAssignedTasks => _myAssignedTasks;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  /// Get my assigned tasks for member role
  /// Returns TaskResponseModel if successful, null if failed
  /// Throws exception with error message - Controller should handle UI feedback
  Future<TaskResponseModel?> getMyAssignedTasks() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;

      final response = await _apiProvider.get('/tasks/my-assigned');

      if (response.statusCode == 200) {
        final taskResponse = TaskResponseModel.fromJson(response.data);

        if (taskResponse.success) {
          _myAssignedTasks.value = taskResponse.data;
        }

        return taskResponse;
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch tasks';

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

      _errorMessage.value = errorMessage;
      throw errorMessage;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _errorMessage.value = errorMessage;
      throw errorMessage;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// Get all tasks (for supervisor role)
  /// Returns TaskResponseModel if successful, null if failed
  /// Throws exception with error message - Controller should handle UI feedback
  Future<TaskResponseModel?> getAllTasks() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;

      final response = await _apiProvider.get('/tasks');

      if (response.statusCode == 200) {
        final taskResponse = TaskResponseModel.fromJson(response.data);

        if (taskResponse.success) {
          _myAssignedTasks.value = taskResponse.data;
        }

        return taskResponse;
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch tasks';

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

      _errorMessage.value = errorMessage;
      throw errorMessage;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _errorMessage.value = errorMessage;
      throw errorMessage;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Clear stored tasks (e.g., on logout)
  void clearTasks() {
    _myAssignedTasks.clear();
    _errorMessage.value = null;
  }
  
  /// Create a new task (for supervisor)
  /// POST /tasks
  Future<Map<String, dynamic>?> createTask({
    required String subject,
    required String description,
    required String dueDate, // Format: "2026-02-15"
    required String location,
    required List<int> assignedTo, // User IDs
    required String customerName,
    required int creatorId,
  }) async {
    try {
      final requestData = {
        'subject': subject,
        'description': description,
        'due_date': dueDate,
        'location': location,
        'assigned_to': assignedTo,
        'customer_name': customerName,
        'creator_id': creatorId,
      };

      final response = await _apiProvider.post(
        '/tasks',
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to create task';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw errorMessage;
    } catch (e) {
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// GET /tasks/:id - Get task detail by ID
  Future<TaskModel?> getTaskById(int taskId) async {
    try {
      final response = await _apiProvider.get('/tasks/$taskId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['success'] == true && data['data'] != null) {
          return TaskModel.fromJson(data['data']);
        }
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch task detail';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw errorMessage;
    } catch (e) {
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// PUT /tasks/:id - Update task
  Future<Map<String, dynamic>?> updateTask({
    required int taskId,
    required String subject,
    required String description,
    required String dueDate, // Format: "2026-02-15"
    required String location,
    required List<int> assignedTo, // User IDs
    required String customerName,
  }) async {
    try {
      final requestData = {
        'subject': subject,
        'description': description,
        'due_date': dueDate,
        'location': location,
        'assigned_to': assignedTo,
        'customer_name': customerName,
      };

      final response = await _apiProvider.put(
        '/tasks/$taskId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to update task';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw errorMessage;
    } catch (e) {
      throw 'An error occurred: ${e.toString()}';
    }
  }
}
