import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../models/task_model.dart';
import '../models/task_submission_model.dart';
import '../models/task_assignment_model.dart';
import '../models/task_comment_model.dart';
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

  /// GET /tasks/:id - Get task detail with assignments
  Future<TaskWithAssignmentsModel?> getTaskWithAssignments(int taskId) async {
    try {
      print('Fetching task with assignments for ID: $taskId');

      final response = await _apiProvider.get('/tasks/$taskId');

      print('Task with assignments response status: ${response.statusCode}');
      print('Task with assignments response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['success'] == true && data['data'] != null) {
          return TaskWithAssignmentsModel.fromJson(data['data']);
        }
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch task with assignments';

      if (e.response != null) {
        print('Task with assignments error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Task with assignments error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Task with assignments unexpected error: $e');
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

  /// POST /tasks/assignment/:assignmentId/submit - Submit task work
  Future<TaskSubmissionResponseModel?> submitTaskWork({
    required int assignmentId,
    required String filePath,
    String submissionType = 'file',
  }) async {
    try {
      // Create FormData for multipart upload
      final formData = FormData.fromMap({
        'submission_type': submissionType,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      print('Submitting task to: /tasks/assignment/$assignmentId/submit');
      print('File path: $filePath');
      print('Submission type: $submissionType');

      final response = await _apiProvider.post(
        '/tasks/assignment/$assignmentId/submit',
        data: formData,
      );

      print('Submit response status: ${response.statusCode}');
      print('Submit response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskSubmissionResponseModel.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to submit task';

      if (e.response != null) {
        print('Submit error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Submit error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Submit unexpected error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// GET /tasks/assignment/:assignmentId/submissions - Get task submissions
  Future<List<TaskSubmissionModel>> getTaskSubmissions({
    required int assignmentId,
  }) async {
    try {
      print('Fetching submissions for assignment: $assignmentId');

      final response = await _apiProvider.get(
        '/tasks/assignment/$assignmentId/submissions',
      );

      print('Submissions response status: ${response.statusCode}');
      print('Submissions response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['success'] == true && data['data'] != null) {
          final submissions = (data['data'] as List)
              .map((item) => TaskSubmissionModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return submissions;
        }
      }

      return [];
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch submissions';

      if (e.response != null) {
        print('Submissions error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Submissions error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Submissions unexpected error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Get comments for an assignment
  /// GET /tasks/assignment/:assignmentId/comments
  Future<List<TaskCommentModel>> getAssignmentComments({
    required int assignmentId,
  }) async {
    try {
      print('=== GET ASSIGNMENT COMMENTS ===');
      print('Assignment ID: $assignmentId');

      final response = await _apiProvider.get(
        '/tasks/assignment/$assignmentId/comments',
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final commentResponse = TaskCommentResponseModel.fromJson(response.data);

        if (commentResponse.success) {
          print('Comments loaded: ${commentResponse.data.length}');
          return commentResponse.data;
        }

        throw commentResponse.message;
      }

      throw 'Failed to load comments: ${response.statusCode}';
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch comments';

      if (e.response != null) {
        print('Comments error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Comments error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Comments unexpected error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Post a comment on an assignment
  /// POST /tasks/assignment/:assignmentId/comments
  Future<TaskCommentModel> postAssignmentComment({
    required int assignmentId,
    required String commentText,
  }) async {
    try {
      print('=== POST ASSIGNMENT COMMENT ===');
      print('Assignment ID: $assignmentId');
      print('Comment: $commentText');

      final response = await _apiProvider.post(
        '/tasks/assignment/$assignmentId/comments',
        data: {
          'comment_text': commentText,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final commentResponse = TaskCommentCreateResponseModel.fromJson(response.data);

        if (commentResponse.success) {
          print('Comment created: ${commentResponse.data.id}');
          return commentResponse.data;
        }

        throw commentResponse.message;
      }

      throw 'Failed to post comment: ${response.statusCode}';
    } on DioException catch (e) {
      String errorMessage = 'Failed to post comment';

      if (e.response != null) {
        print('Post comment error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Post comment error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Post comment unexpected error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }
}
