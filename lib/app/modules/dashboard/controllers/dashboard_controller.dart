import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/task_service.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/task_item.dart';
import '../../../data/models/task_model.dart' as data_model;
import '../../../routes/app_pages.dart';
import '../../../utils/date_helper.dart';
import '../../navigation/controllers/navigation_controller.dart';

class DashboardController extends GetxController {
  // Lazy initialization of AuthService
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }

  // Lazy initialization of TaskService
  TaskService? get _taskService {
    try {
      return Get.find<TaskService>();
    } catch (e) {
      return null;
    }
  }

  // User role: 'supervisor' or 'member'
  final userRole = 'member'.obs;

  // User info
  final userName = ''.obs;
  final userPosition = ''.obs;
  final userAvatar = ''.obs;

  // Current date info
  final currentDate = DateHelper.nowWib().obs;
  final workStatus = 'Working'.obs;
  final workStartTime = '08:00 AM'.obs;
  final workEndTime = '05:00 PM'.obs;
  final workLocation =
      'Jl. Orchard Boulevard, Belian, Kec. Batam Kota, Kota Batam, Kepulauan Riau 29464'
          .obs;

  // Department list for supervisor
  final departments = <DepartmentModel>[
    DepartmentModel(
      id: '1',
      name: 'Executive Management',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    ),
    DepartmentModel(
      id: '2',
      name: 'Project & Product',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    ),
    DepartmentModel(
      id: '3',
      name: 'Engineering / Development',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    ),
    DepartmentModel(
      id: '4',
      name: 'UI/UX & Design',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    ),
  ].obs;

  // User's department (for member view)
  final userDepartment = DepartmentModel(
    id: '1',
    name: 'Executive Management',
    imageUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
  ).obs;

  // Ongoing tasks for member (populated from API)
  final ongoingTasks = <DashboardTaskItem>[].obs;

  // Store full TaskModel for navigation (key: taskId)
  final RxMap<int, data_model.TaskModel> _taskModelMap = <int, data_model.TaskModel>{}.obs;

  // Loading state for tasks
  final isTasksLoading = false.obs;

  // Search controller
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _lastBackPressedTime = null;
    _loadUserData();
    _loadOngoingTasks();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadUserData() {
    final authService = _authService;
    if (authService != null) {
      final user = authService.currentUser;
      if (user != null) {
        userName.value = user.displayName;
        userRole.value = user.role;
        userPosition.value = user.role;
      }
    }
  }

  /// Load ongoing tasks from TaskService (for member role only)
  Future<void> _loadOngoingTasks() async {
    final taskService = _taskService;
    if (taskService == null) return;

    try {
      isTasksLoading.value = true;

      // Only load tasks for member role
      if (userRole.value == 'member') {
        final response = await taskService.getMyAssignedTasks();

        if (response != null && response.success) {
          // Filter for incomplete tasks (not submitted)
          final incompleteTasks = response.data
              .where((task) =>
                  !task.isSubmitted && task.status.toLowerCase() != 'completed')
              .toList();

          // Convert to DashboardTaskItem and store full model
          final dashboardItems = <DashboardTaskItem>[];
          _taskModelMap.clear();

          for (final task in incompleteTasks) {
            dashboardItems.add(DashboardTaskItem(
              id: task.taskId.toString(),
              title: task.taskSubject,
              dueDate: task.dueDate,
            ));
            _taskModelMap[task.taskId] = task;
          }

          ongoingTasks.value = dashboardItems;
        }
      }
    } catch (e) {
      // Silently fail - tasks will show empty
      print('Error loading tasks: $e');
    } finally {
      isTasksLoading.value = false;
    }
  }

  /// Refresh tasks (call after task status change)
  Future<void> refreshTasks() async {
    await _loadOngoingTasks();
  }

  void toggleUserRole() {
    if (userRole.value == 'supervisor') {
      userRole.value = 'member';
      userPosition.value = 'Chief Executive Officer';
    } else {
      userRole.value = 'supervisor';
      userPosition.value = 'Supervisor A';
    }
  }

  bool get isSupervisor => userRole.value == 'supervisor';

  String get formattedDate {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final date = currentDate.value;
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatTaskDueDate(DateTime date) {
    return DateHelper.formatDueDateWib(date);
  }

  /// Search handler
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  /// Navigate to notifications
  void openNotifications() {
    Get.toNamed(Routes.NOTIFICATIONS);
  }

  /// Navigate to profile
  void openProfile() {
    Get.toNamed(Routes.PROFILE);
  }

  /// Logout user
  void logout() async {
    final authService = _authService;
    if (authService != null) {
      await authService.logout();
    }
    Get.offAllNamed(Routes.LOGIN);
  }

  /// Navigate to attendance
  void openAttendance() {
    Get.toNamed(Routes.ATTENDANCE);
  }

  /// Navigate to report
  void openReport() {
    Get.toNamed(Routes.ATTENDANCE_REPORT);
  }

  /// Navigate to members
  void openMembers() {
    Get.toNamed(Routes.MEMBERS_LIST);
  }

  void createNewDepartment() {
    Get.toNamed(Routes.CREATE_DEPARTMENT);
  }

  void seeMoreTasks() => NavigationController.navigateToTask();

  void openDepartment(DepartmentModel department) {
    Get.toNamed(Routes.DEPARTMENT_DETAIL, arguments: department);
  }

  void clockIn() {
    Get.toNamed(Routes.TAKE_ATTENDANCE);
  }

  void openTask(DashboardTaskItem task) {
    // Get the full TaskModel from map
    final taskId = int.tryParse(task.id);
    final fullTask = taskId != null ? _taskModelMap[taskId] : null;

    // For members, navigate to user task detail with full task model
    Get.toNamed(
      Routes.USER_TASK_DETAIL,
      arguments: fullTask ?? task,
    );
  }

  // Double back to exit
  DateTime? _lastBackPressedTime;

  Future<bool> handleWillPop() async {
    final currentTime = DateTime.now();
    final canExit = _lastBackPressedTime != null &&
        currentTime.difference(_lastBackPressedTime!) < const Duration(seconds: 2);

    _lastBackPressedTime = currentTime;

    if (canExit) {
      return true;
    }

    _showSnackbar('Exit', 'Press back again to exit');
    return false;
  }

  void _showSnackbar(String title, [String? message]) {
    Get.snackbar(
      title,
      message ?? 'Coming soon!',
      snackPosition: SnackPosition.TOP,
    );
  }
}
