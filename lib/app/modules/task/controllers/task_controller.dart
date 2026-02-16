import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart' as data_model;
import '../../../data/models/task_assignment_model.dart';
import '../../../data/services/task_service.dart';
import '../../../utils/date_helper.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class TaskController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();

  // Observable states
  final selectedFilter = 'All'.obs;
  final scrollController = ScrollController();
  final isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  // Get userRole from DashboardController
  DashboardController? get _dashboardController {
    try {
      return Get.find<DashboardController>();
    } catch (e) {
      return null;
    }
  }

  // User role from DashboardController: 'supervisor' or 'member'
  RxString get userRole => _dashboardController?.userRole ?? 'member'.obs;

  // Observable list of tasks
  final RxList<data_model.TaskModel> tasks = <data_model.TaskModel>[].obs;

  // Map to store computed effective status for supervisor tasks (taskId -> effectiveStatus)
  // The effective status is computed from the aggregate of all member assignment statuses
  final Map<int, String> _effectiveStatusMap = {};

  // Filter options - same status filters for both supervisor and member
  List<String> get filters {
    // if (isSupervisor) {
    //   // Supervisor sees department filters
    //   return ['All', 'Engineering', 'Marketing', 'Sales', 'HR'];
    // }
    // Status filters for all roles
    return ['All', 'Pending', 'In Progress', 'Completed', 'Cancelled'];
  }

  @override
  void onInit() {
    super.onInit();
    if (userRole.value == 'member') {
      fetchMyTasks();
    } else if (userRole.value == 'supervisor') {
      fetchAllTasks();
    }
  }

  /// Fetch my tasks from API (for member role)
  Future<void> fetchMyTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await _taskService.getMyTasksWithCustomerName();

      if (response != null && response.success) {
        tasks.value = response.data;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch my assigned tasks from API (for member role)
  Future<void> fetchMyAssignedTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await _taskService.getMyAssignedTasks();

      if (response != null && response.success) {
        tasks.value = response.data;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all tasks from API (for supervisor role)
  /// Also fetches each task's assignments to compute effective status
  Future<void> fetchAllTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      _effectiveStatusMap.clear();

      final response = await _taskService.getAllTasks();

      if (response != null && response.success) {
        tasks.value = response.data;

        // Fetch assignments for each task to compute effective status
        for (final task in response.data) {
          try {
            final taskDetail = await _taskService.getTaskWithAssignments(
              task.id,
            );
            if (taskDetail != null && taskDetail.assignments.isNotEmpty) {
              final effectiveStatus = _computeEffectiveStatus(
                taskDetail.assignments,
              );
              _effectiveStatusMap[task.id] = effectiveStatus;
              print(
                '📋 Task "${task.taskSubject}" -> API status="${task.status}", effective="${effectiveStatus}"',
              );
            } else {
              // No assignments, use the task's own status
              _effectiveStatusMap[task.id] = task.status;
              print(
                '📋 Task "${task.taskSubject}" -> API status="${task.status}" (no assignments)',
              );
            }
          } catch (e) {
            // If fetching detail fails, fall back to the task's own status
            _effectiveStatusMap[task.id] = task.status;
            print(
              '📋 Task "${task.taskSubject}" -> API status="${task.status}" (detail fetch failed: $e)',
            );
          }
        }

        // Trigger UI refresh after effective statuses are computed
        tasks.refresh();
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  /// Compute the effective (aggregate) status from all member assignment statuses.
  ///
  /// Logic:
  /// - If ALL assignments are 'completed' -> 'completed'
  /// - If ALL assignments are 'cancelled' -> 'cancelled'
  /// - If ANY assignment is 'in_progress' (and not all completed) -> 'in_progress'
  /// - Otherwise -> 'pending'
  String _computeEffectiveStatus(List<TaskAssignmentModel> assignments) {
    if (assignments.isEmpty) return 'pending';

    final statuses = assignments.map((a) => a.status.toLowerCase()).toList();

    // All completed
    if (statuses.every((s) => s == 'completed')) {
      return 'completed';
    }

    // All cancelled
    if (statuses.every((s) => s == 'cancelled' || s == 'canceled')) {
      return 'cancelled';
    }

    // Any in_progress or completed (but not all completed) -> in_progress
    if (statuses.any((s) => s == 'in_progress' || s == 'completed')) {
      return 'in_progress';
    }

    // Default: pending
    return 'pending';
  }

  /// Get the effective status for a task (supervisor: computed from assignments, member: task's own status)
  String _getEffectiveStatus(data_model.TaskModel task) {
    if (isSupervisor && _effectiveStatusMap.containsKey(task.id)) {
      return _effectiveStatusMap[task.id]!;
    }
    return task.status;
  }

  /// Get tasks grouped by month
  Map<String, List<data_model.TaskModel>> get groupedTasks {
    final grouped = <String, List<data_model.TaskModel>>{};

    for (final task in filteredTasks) {
      final monthKey = _getMonthKey(task.dueDate);
      grouped.putIfAbsent(monthKey, () => []);
      grouped[monthKey]!.add(task);
    }

    // Sort months in descending order (newest first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => _parseMonthKey(b).compareTo(_parseMonthKey(a)));

    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  /// Normalize status by removing underscores and hyphens, and unifying spelling (for comparison)
  String _normalizeStatus(String status) {
    String normalized = status
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ');
    // Unify British/American spelling: "cancelled" -> "canceled"
    normalized = normalized.replaceAll('cancelled', 'canceled');
    return normalized;
  }

  /// Get filtered tasks based on selected status filter
  List<data_model.TaskModel> get filteredTasks {
    if (selectedFilter.value == 'All') {
      return tasks;
    }

    // Filter by effective status (uses computed aggregate for supervisor)
    return tasks.where((task) {
      final effectiveStatus = _getEffectiveStatus(task);
      return _normalizeStatus(effectiveStatus) ==
          _normalizeStatus(selectedFilter.value);
    }).toList();
  }

  /// Parse month key string to DateTime for sorting
  DateTime _parseMonthKey(String monthKey) {
    final parts = monthKey.split(' ');
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    final month = months[parts[0]] ?? 1;
    final year = int.tryParse(parts[1]) ?? DateTime.now().year;
    return DateTime(year, month);
  }

  /// Get month key from DateTime
  String _getMonthKey(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Select filter (toggle: clicking the same filter resets to 'All')
  void selectFilter(String filter) {
    if (selectedFilter.value == filter) {
      selectedFilter.value = 'All';
    } else {
      selectedFilter.value = filter;
    }
  }

  /// Format date to display format (WIB)
  String formatDate(DateTime date) {
    return DateHelper.formatDateWib(date);
  }

  /// Format date with time (WIB)
  String formatDateTime(DateTime date) {
    return DateHelper.formatDateTimeWib(date);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Check if current user is supervisor/admin
  bool get isSupervisor => userRole.value == 'supervisor';

  /// Navigate to task detail based on user role
  /// Supervisor/Admin -> TaskDetailView (with tabs)
  /// Member -> UserTaskDetailView (with status, upload, submit button)
  void openTaskDetail(data_model.TaskModel task) async {
    if (userRole.value == 'supervisor') {
      final result = await Get.toNamed(
        '/task-detail',
        arguments: {'taskId': task.id},
      );
      // Refresh after edit if result is true
      if (result == true) {
        await refresh();
      }
    } else {
      Get.toNamed('/user-task-detail', arguments: task);
    }
  }

  /// Refresh tasks
  @override
  Future<void> refresh() async {
    if (userRole.value == 'member') {
      await fetchMyTasks();
    } else if (userRole.value == 'supervisor') {
      await fetchAllTasks();
    }
  }
}
