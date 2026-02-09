import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/task_assignment_model.dart';
import '../../../data/models/task_submission_model.dart';
import '../../../data/services/task_service.dart';

class TaskDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final selectedTabIndex = 0.obs;
  final isLoading = true.obs;
  final Rxn<TaskModel> task = Rxn<TaskModel>();
  final Rxn<TaskWithAssignmentsModel> taskWithAssignments = Rxn<TaskWithAssignmentsModel>();

  late final TaskService _taskService;

  // Task data from API
  final taskTitle = ''.obs;
  final postedOn = Rxn<DateTime>();
  final dueDate = Rxn<DateTime>();
  final description = ''.obs;
  final customerName = ''.obs;
  final location = ''.obs;
  final creatorName = ''.obs;
  final creatorEmail = ''.obs;

  // Task ID passed as argument
  int? get taskId => Get.arguments?['taskId'] as int?;

  // Employee work statistics
  final approvedCount = 0.obs;
  final lateSubmissionsCount = 0.obs;

  // Employee work data (now observable and dynamic)
  final RxList<EmployeeWorkModel> approvedEmployees = <EmployeeWorkModel>[].obs;
  final RxList<EmployeeWorkModel> lateEmployees = <EmployeeWorkModel>[].obs;
  final RxList<EmployeeWorkModel> assignedEmployees = <EmployeeWorkModel>[].obs;

  // Submission data cache
  final Map<int, TaskSubmissionModel> _submissionsCache = {};

  @override
  void onInit() {
    super.onInit();
    _taskService = Get.find<TaskService>();
    
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });

    // Load task detail
    if (taskId != null) {
      loadTaskDetail();
    }
  }

  /// Load task detail from API with assignments
  Future<void> loadTaskDetail() async {
    try {
      isLoading.value = true;
      
      // Get task with assignments
      final taskData = await _taskService.getTaskWithAssignments(taskId!);
      
      if (taskData != null) {
        taskWithAssignments.value = taskData;
        
        // Also set the basic task for backward compatibility
        task.value = TaskModel(
          id: taskData.id,
          taskId: taskData.id,
          taskSubject: taskData.subject,
          taskDescription: taskData.description,
          customerName: taskData.customerName,
          location: taskData.location,
          status: 'active', // Default status as it's not in TaskWithAssignmentsModel
          dueDate: taskData.dueDate,
          createdAt: taskData.createdAt,
          updatedAt: taskData.updatedAt,
          creatorName: taskData.creatorName,
          creatorEmail: taskData.creatorEmail,
          isSubmitted: false, // This is per-assignment, not per-task
        );
        
        // Populate observable fields
        taskTitle.value = taskData.subject;
        postedOn.value = taskData.createdAt;
        dueDate.value = taskData.dueDate;
        description.value = taskData.description;
        customerName.value = taskData.customerName ?? '';
        location.value = taskData.location;
        creatorName.value = taskData.creatorName ?? '';
        creatorEmail.value = taskData.creatorEmail ?? '';

        // Process assignments for Employee Work tab
        await _processAssignments(taskData.assignments);
      } else {
        Get.snackbar(
          'Error',
          'Failed to load task detail',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Process assignments and categorize employees
  Future<void> _processAssignments(List<TaskAssignmentModel> assignments) async {
    // Clear previous data
    approvedEmployees.clear();
    lateEmployees.clear();
    assignedEmployees.clear();
    _submissionsCache.clear();
    
    int approvedTotal = 0;
    int lateTotal = 0;

    for (var assignment in assignments) {
      if (assignment.isSubmitted) {
        // Fetch submission details
        final submissions = await _taskService.getTaskSubmissions(
          assignmentId: assignment.id,
        );
        
        if (submissions.isNotEmpty) {
          final submission = submissions.first;
          _submissionsCache[assignment.id] = submission;

          // Check if submission is late
          final isLate = _isSubmissionLate(submission.submittedAt, dueDate.value);
          
          final employee = EmployeeWorkModel(
            id: assignment.userId.toString(),
            name: assignment.username,
            avatarUrl: 'https://i.pravatar.cc/150?u=${assignment.userEmail}',
            status: isLate ? EmployeeWorkStatus.late : EmployeeWorkStatus.onTime,
            assignmentId: assignment.id,
            submissionDate: submission.submittedAt,
          );

          if (isLate) {
            lateEmployees.add(employee);
            lateTotal++;
          } else {
            approvedEmployees.add(employee);
            approvedTotal++;
          }
        }
      } else {
        // Not submitted yet
        final employee = EmployeeWorkModel(
          id: assignment.userId.toString(),
          name: assignment.username,
          avatarUrl: 'https://i.pravatar.cc/150?u=${assignment.userEmail}',
          status: EmployeeWorkStatus.notSubmitted,
          assignmentId: assignment.id,
        );
        assignedEmployees.add(employee);
      }
    }

    // Update statistics
    approvedCount.value = approvedTotal;
    lateSubmissionsCount.value = lateTotal;
  }

  /// Check if a submission is late
  bool _isSubmissionLate(DateTime? submittedAt, DateTime? dueDateTime) {
    if (submittedAt == null || dueDateTime == null) return false;
    return submittedAt.isAfter(dueDateTime);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Format date to display
  String formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Edit task
  void editTask() async {
    if (task.value == null) {
      Get.snackbar(
        'Error',
        'Task data not loaded',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to edit task with task object
    final result = await Get.toNamed(
      '/edit-task',
      arguments: {
        'taskId': taskId,
        'task': task.value,
      },
    );

    // Reload task detail if edit was successful
    if (result == true && taskId != null) {
      await loadTaskDetail();
    }
  }
}

enum EmployeeWorkStatus { onTime, late, notSubmitted }

class EmployeeWorkModel {
  final String id;
  final String name;
  final String avatarUrl;
  final EmployeeWorkStatus status;
  final int? assignmentId;
  final DateTime? submissionDate;

  EmployeeWorkModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.status,
    this.assignmentId,
    this.submissionDate,
  });

  String get statusText {
    switch (status) {
      case EmployeeWorkStatus.onTime:
        return 'Tepat Waktu';
      case EmployeeWorkStatus.late:
        return 'Terlambat';
      case EmployeeWorkStatus.notSubmitted:
        return 'Tidak mengumpulkan';
    }
  }

  Color get statusColor {
    switch (status) {
      case EmployeeWorkStatus.onTime:
        return const Color(0xFF4CAF50);
      case EmployeeWorkStatus.late:
        return const Color(0xFFF44336);
      case EmployeeWorkStatus.notSubmitted:
        return const Color(0xFF9E9E9E);
    }
  }
}
