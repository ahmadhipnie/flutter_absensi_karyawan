import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/department_service.dart';
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

  // Department Service
  final DepartmentService _departmentService = DepartmentService();

  // User role: 'supervisor' or 'member'
  final userRole = 'member'.obs;

  // User info
  final userName = ''.obs;
  final userPosition = ''.obs;
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
  final departments = <DepartmentModel>[].obs;
  final isLoadingDepartments = false.obs;

  // User's department (for member view)
  final userDepartment = Rxn<DepartmentModel>();

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
    _lastBackPressedTime = null;
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
        userName.value = user.displayName;
        userRole.value = user.role;
        userPosition.value = user.role;
        
        // Load departments if user is supervisor
        if (isSupervisor) {
          loadDepartments();
        }
      }
    }
  }

  /// Load departments from API
  Future<void> loadDepartments() async {
    try {
      isLoadingDepartments.value = true;
      final departmentsList = await _departmentService.getDepartments();
      departments.value = departmentsList;
    } catch (e) {
      _showSnackbar('Error', 'Failed to load departments: ${e.toString()}');
      print('Error loading departments: $e');
    } finally {
      isLoadingDepartments.value = false;
    }
  }

  /// Pull-to-refresh handler
  Future<void> onRefresh() async {
    _loadUserData();
    if (isSupervisor) {
      await loadDepartments();
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

  void createNewDepartment() async {
    final result = await Get.toNamed(Routes.CREATE_DEPARTMENT);
    
    // Refresh departments list if department was created
    if (result == true) {
      loadDepartments();
    }
  }

  void seeMoreTasks() => _showSnackbar('Tasks', 'Navigate to tasks...');

  void openDepartment(DepartmentModel department) async {
    final result = await Get.toNamed(Routes.DEPARTMENT_DETAIL, arguments: department);
    
    // Refresh departments if data was changed (edit/delete)
    if (result == true) {
      loadDepartments();
    }
  }

  void clockIn() {
    Get.toNamed(Routes.TAKE_ATTENDANCE);
  }

  void openTask(DashboardTaskItem task) =>
      _showSnackbar('Task', 'Opening task: ${task.title}');

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
