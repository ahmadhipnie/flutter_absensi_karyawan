import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/task_service.dart';

class TaskDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final selectedTabIndex = 0.obs;
  final isLoading = true.obs;
  final Rxn<TaskModel> task = Rxn<TaskModel>();

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
  final approvedCount = 10.obs;
  final lateSubmissionsCount = 20.obs;

  // Employee work data
  final List<EmployeeWorkModel> approvedEmployees = [
    EmployeeWorkModel(
      id: '1',
      name: 'Karina',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      status: EmployeeWorkStatus.onTime,
    ),
    EmployeeWorkModel(
      id: '2',
      name: 'Bambang',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      status: EmployeeWorkStatus.late,
    ),
  ];

  final List<EmployeeWorkModel> lateEmployees = [
    EmployeeWorkModel(
      id: '3',
      name: 'Jessylin',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      status: EmployeeWorkStatus.late,
    ),
    EmployeeWorkModel(
      id: '4',
      name: 'Gerald',
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
      status: EmployeeWorkStatus.late,
    ),
  ];

  final List<EmployeeWorkModel> assignedEmployees = [
    EmployeeWorkModel(
      id: '5',
      name: 'Jessica',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      status: EmployeeWorkStatus.notSubmitted,
    ),
    EmployeeWorkModel(
      id: '6',
      name: 'Karolin',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      status: EmployeeWorkStatus.notSubmitted,
    ),
    EmployeeWorkModel(
      id: '7',
      name: 'Karolin2',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      status: EmployeeWorkStatus.notSubmitted,
    ),
  ];

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

  /// Load task detail from API
  Future<void> loadTaskDetail() async {
    try {
      isLoading.value = true;
      
      final taskData = await _taskService.getTaskById(taskId!);
      
      if (taskData != null) {
        task.value = taskData;
        
        // Populate observable fields
        taskTitle.value = taskData.taskSubject;
        postedOn.value = taskData.createdAt;
        dueDate.value = taskData.dueDate;
        description.value = taskData.taskDescription;
        customerName.value = taskData.customerName ?? '';
        location.value = taskData.location;
        creatorName.value = taskData.creatorName ?? '';
        creatorEmail.value = taskData.creatorEmail ?? '';
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

  EmployeeWorkModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.status,
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
