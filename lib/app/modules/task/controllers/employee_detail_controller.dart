import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../../../data/models/task_comment_model.dart';
import 'task_detail_controller.dart';

class EmployeeDetailController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();
  final commentController = TextEditingController();

  // Employee work data - now loaded from arguments
  final employeeName = ''.obs;
  final taskSubject = ''.obs;
  final submissionDate = Rxn<DateTime>();
  final status = ''.obs;
  final statusColor = const Color(0xFF4CAF50).obs;
  final approvalStatus = 'Approved'.obs;

  // Assignment and task IDs
  final assignmentId = Rxn<int>();
  final taskId = Rxn<int>();

  // Output files - loaded from API
  final RxList<Map<String, String>> outputFiles = <Map<String, String>>[].obs;

  // Loading state
  final isLoading = true.obs;

  // Comments
  final RxList<CommentModel> comments = <CommentModel>[].obs;

  // Comment loading states
  final isLoadingComments = false.obs;
  final isSendingComment = false.obs;

  // Approval status options
  final List<String> approvalOptions = ['Approved', 'Pending', 'Rejected'];

  @override
  void onInit() {
    super.onInit();
    _loadEmployeeData();
  }

  /// Load employee data from arguments and API
  Future<void> _loadEmployeeData() async {
    try {
      isLoading.value = true;

      // Get data from arguments
      final arguments = Get.arguments as Map<String, dynamic>?;
      
      if (arguments != null) {
        assignmentId.value = arguments['assignmentId'] as int?;
        taskId.value = arguments['taskId'] as int?;
        employeeName.value = arguments['employeeName'] as String? ?? '';
        taskSubject.value = arguments['taskSubject'] as String? ?? '';
        submissionDate.value = arguments['submissionDate'] as DateTime?;
        
        // Set status and color
        final employeeStatus = arguments['status'] as EmployeeWorkStatus?;
        if (employeeStatus != null) {
          switch (employeeStatus) {
            case EmployeeWorkStatus.onTime:
              status.value = 'Tepat Waktu';
              statusColor.value = const Color(0xFF4CAF50);
              break;
            case EmployeeWorkStatus.late:
              status.value = 'Terlambat';
              statusColor.value = const Color(0xFFF44336);
              break;
            case EmployeeWorkStatus.notSubmitted:
              status.value = 'Tidak mengumpulkan';
              statusColor.value = const Color(0xFF9E9E9E);
              break;
          }
        }

        // Fetch submission details if submitted
        if (assignmentId.value != null && 
            employeeStatus != EmployeeWorkStatus.notSubmitted) {
          await _loadSubmissionDetails();
          await _loadComments();
        }
      }
    } catch (e) {
      print('Error loading employee data: $e');
      Get.snackbar(
        'Error',
        'Failed to load employee details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load submission details from API
  Future<void> _loadSubmissionDetails() async {
    if (assignmentId.value == null) return;

    try {
      final submissions = await _taskService.getTaskSubmissions(
        assignmentId: assignmentId.value!,
      );

      if (submissions.isNotEmpty) {
        final submission = submissions.first;
        
        // Add submitted file to output files
        if (submission.fileName != null && submission.fileName!.isNotEmpty) {
          final fileExtension = submission.fileName!.split('.').last.toLowerCase();
          String fileType = 'file';
          
          if (['pdf'].contains(fileExtension)) {
            fileType = 'pdf';
          } else if (['doc', 'docx'].contains(fileExtension)) {
            fileType = 'doc';
          } else if (['xls', 'xlsx'].contains(fileExtension)) {
            fileType = 'xls';
          } else if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
            fileType = 'image';
          }
          
          outputFiles.add({
            'name': submission.fileName!,
            'type': fileType,
            'path': submission.filePath ?? '',
          });
        }
      }
    } catch (e) {
      print('Error loading submission details: $e');
      // Don't show error, just continue without files
    }
  }

  /// Load comments from API
  Future<void> _loadComments() async {
    if (assignmentId.value == null) return;

    try {
      isLoadingComments.value = true;

      final taskComments = await _taskService.getAssignmentComments(
        assignmentId: assignmentId.value!,
      );

      // Convert to UI model
      comments.value = taskComments
          .map((comment) => CommentModel.fromTaskComment(comment))
          .toList();
    } catch (e) {
      print('Error loading comments: $e');
      // Don't show error, just continue with empty comments
    } finally {
      isLoadingComments.value = false;
    }
  }

  /// Format date to display
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Change approval status
  void changeApprovalStatus(String? newStatus) {
    if (newStatus != null) {
      approvalStatus.value = newStatus;
      Get.snackbar('Status Changed', 'Approval status updated to $newStatus');
    }
  }

  /// Send private comment
  Future<void> sendPrivateComment() async {
    if (assignmentId.value == null) return;
    
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    try {
      isSendingComment.value = true;

      final newComment = await _taskService.postAssignmentComment(
        assignmentId: assignmentId.value!,
        commentText: text,
      );

      // Add to list
      comments.add(CommentModel.fromTaskComment(newComment));
      
      // Clear input
      commentController.clear();

      // Show success message
      Get.snackbar(
        'Success',
        'Comment posted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSendingComment.value = false;
    }
  }

  /// Open output file
  void openOutputFile(String fileName) {
    Get.snackbar('Open File', fileName);
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}

class CommentModel {
  final String id;
  final String userName;
  final String comment;
  final String time;

  CommentModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.time,
  });

  /// Create from TaskCommentModel
  factory CommentModel.fromTaskComment(TaskCommentModel taskComment) {
    return CommentModel(
      id: taskComment.id.toString(),
      userName: taskComment.username,
      comment: taskComment.commentText,
      time: taskComment.formattedTime,
    );
  }
}
