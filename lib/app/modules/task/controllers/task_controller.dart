import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart' as data_model;
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

  // Filter options - different for supervisor and member
  List<String> get filters {
    if (isSupervisor) {
      // Supervisor sees department filters
      return ['All', 'Engineering', 'Marketing', 'Sales', 'HR'];
    } else {
      // Member sees status filters
      return ['All', 'Pending', 'In Progress', 'Completed'];
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (userRole.value == 'member') {
      fetchMyAssignedTasks();
    } else if (userRole.value == 'supervisor') {
      fetchAllTasks();
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
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Fetch all tasks from API (for supervisor role)
  Future<void> fetchAllTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await _taskService.getAllTasks();

      if (response != null && response.success) {
        tasks.value = response.data;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
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

  /// Get filtered tasks based on selected status filter
  List<data_model.TaskModel> get filteredTasks {
    if (selectedFilter.value == 'All') {
      return tasks;
    }

    if (isSupervisor) {
      // Filter by department for supervisor
      return tasks.where((task) {
        // Assuming task has a department field, adjust based on actual model
        // For now, filter by location as department proxy
        return task.location.toLowerCase() == selectedFilter.value.toLowerCase();
      }).toList();
    } else {
      // Filter by status for member
      return tasks.where((task) {
        return task.status.toLowerCase() == selectedFilter.value.toLowerCase();
      }).toList();
    }
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

  /// Select filter
  void selectFilter(String filter) {
    selectedFilter.value = filter;
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
      final result = await Get.toNamed('/task-detail', arguments: {'taskId': task.id});
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
      await fetchMyAssignedTasks();
    } else if (userRole.value == 'supervisor') {
      await fetchAllTasks();
    }
  }
}
