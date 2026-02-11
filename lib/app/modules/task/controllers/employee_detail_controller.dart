import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/services/task_service.dart';
import '../../../data/models/task_comment_model.dart';
import '../../../core/config/app_config.dart';
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

  // Assignment status options (from API)
  final List<String> assignmentStatusOptions = [
    'pending',
    'in_progress',
    'completed',
    'cancelled'
  ];

  // Current assignment status
  final assignmentStatus = ''.obs;
  final isUpdatingStatus = false.obs;

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

        // Load assignment status if provided
        final statusFromArgs = arguments['assignmentStatus'] as String?;
        if (statusFromArgs != null && assignmentStatusOptions.contains(statusFromArgs)) {
          assignmentStatus.value = statusFromArgs;
        } else {
          // Default to pending if not provided
          assignmentStatus.value = 'pending';
        }

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

        // Debug: print the submission details
        print('=== SUBMISSION DETAILS ===');
        print('SubmissionType: ${submission.submissionType}');
        print('FileName: ${submission.fileName}');
        print('FilePath: ${submission.filePath}');
        print('ContentUrl: ${submission.contentUrl}');

        // Handle different submission types
        if (submission.submissionType == 'url') {
          // Link submission
          if (submission.contentUrl != null && submission.contentUrl!.isNotEmpty) {
            outputFiles.add({
              'name': submission.contentUrl!,
              'type': 'link',
              'path': submission.contentUrl!,
            });
          }
        } else {
          // File submission
          if (submission.fileName != null && submission.fileName!.isNotEmpty) {
            final fileExtension = submission.fileName!.split('.').last.toLowerCase();
            String iconType = 'file';

            if (['pdf'].contains(fileExtension)) {
              iconType = 'pdf';
            } else if (['doc', 'docx'].contains(fileExtension)) {
              iconType = 'doc';
            } else if (['xls', 'xlsx'].contains(fileExtension)) {
              iconType = 'xls';
            } else if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(fileExtension)) {
              iconType = 'image';
            } else if (['txt'].contains(fileExtension)) {
              iconType = 'txt';
            }

            outputFiles.add({
              'name': submission.fileName!,
              'type': iconType,
              'path': submission.filePath ?? '',
            });
          }
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

  /// Update assignment status
  Future<void> updateAssignmentStatus(String newStatus) async {
    if (assignmentId.value == null) {
      Get.snackbar(
        'Error',
        'Assignment ID not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!assignmentStatusOptions.contains(newStatus)) {
      Get.snackbar(
        'Error',
        'Invalid status',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isUpdatingStatus.value = true;

      final result = await _taskService.updateAssignmentStatus(
        assignmentId: assignmentId.value!,
        status: newStatus,
      );

      if (result != null && result['success'] == true) {
        assignmentStatus.value = newStatus;

        Get.snackbar(
          'Success',
          'Assignment status updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
      } else {
        throw 'Failed to update status';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  /// Get display text for assignment status
  String getAssignmentStatusDisplay(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  /// Get color for assignment status
  Color getAssignmentStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFA726); // Orange
      case 'in_progress':
        return const Color(0xFF42A5F5); // Blue
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'cancelled':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
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

  /// Open output file or link - uses filePath from submissions API
  Future<void> openOutputFile(String filePath, {String fileType = 'file'}) async {
    if (filePath.isEmpty) {
      Get.snackbar(
        'Error',
        'File path is empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      String? targetUrl;

      if (fileType == 'link') {
        // Link submission - open directly
        targetUrl = filePath;
      } else {
        // File submission - use preview endpoint
        targetUrl = AppConfig.getTaskFilePreviewUrl(filePath);
      }

      if (targetUrl == null || targetUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'Invalid URL',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      print('Opening URL in browser: $targetUrl');

      final uri = Uri.parse(targetUrl);

      // Open in external browser
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Error opening file: $e');
      Get.snackbar(
        'Error',
        'Failed to open file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
  final String? avatarUrl; // Added for profile photo

  CommentModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.time,
    this.avatarUrl,
  });

  /// Create from TaskCommentModel
  factory CommentModel.fromTaskComment(TaskCommentModel taskComment) {
    return CommentModel(
      id: taskComment.id.toString(),
      userName: taskComment.username,
      comment: taskComment.commentText,
      time: taskComment.formattedTime,
      avatarUrl: taskComment.avatarUrl, // Pass the avatar URL
    );
  }
}
