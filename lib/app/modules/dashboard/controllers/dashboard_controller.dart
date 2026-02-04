import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/task_item.dart';
import '../../../routes/app_pages.dart';

class DashboardController extends GetxController {
  // Lazy initialization of AuthService
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }

  // User role: 'supervisor' or 'member'
  final userRole = 'member'.obs;

  // User info
  final userName = 'Alsaa Cantikk'.obs;
  final userPosition = 'Chief Executive Officer'.obs;
  final userAvatar = ''.obs;

  // Current date info
  final currentDate = DateTime.now().obs;
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

  // Ongoing tasks for member
  final ongoingTasks = <DashboardTaskItem>[
    DashboardTaskItem(
      id: '1',
      title: "Set the company's vision and strategic direction",
      dueDate: DateTime(2026, 1, 17, 23, 59),
    ),
    DashboardTaskItem(
      id: '2',
      title: 'Make high-level strategic decisions',
      dueDate: DateTime(2026, 1, 17, 23, 59),
    ),
    DashboardTaskItem(
      id: '3',
      title: 'Lead and oversee executive management',
      dueDate: DateTime(2026, 1, 17, 23, 59),
    ),
  ].obs;

  // Search controller
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
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
        userName.value = user['name'] ?? 'User';
      }
    }
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
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return 'Due ${date.day} ${months[date.month - 1]} ${date.year}, ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $amPm';
  }

  /// Search handler
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  /// Navigate to notifications
  void openNotifications() {
    Get.snackbar('Notifications', 'Coming soon!',
        snackPosition: SnackPosition.BOTTOM);
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

  void seeMoreTasks() => _showSnackbar('Tasks', 'Navigate to tasks...');

  void openDepartment(DepartmentModel department) {
    Get.toNamed(Routes.DEPARTMENT_DETAIL, arguments: department);
  }

  void clockIn() {
    Get.snackbar(
      'Clock In',
      'Clock in successful!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void openTask(DashboardTaskItem task) =>
      _showSnackbar('Task', 'Opening task: ${task.title}');

  void _showSnackbar(String title, [String? message]) {
    Get.snackbar(
      title,
      message ?? 'Coming soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
