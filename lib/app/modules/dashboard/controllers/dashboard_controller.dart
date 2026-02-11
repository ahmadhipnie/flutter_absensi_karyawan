import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
import '../../../data/services/auth_service.dart';
import '../../../data/services/task_service.dart';
import '../../../data/services/department_service.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/attendance_service.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/task_item.dart';
import '../../../data/models/task_model.dart' as data_model;
import '../../../data/models/attendance_model.dart';
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
  // Department Service
  final DepartmentService _departmentService = DepartmentService();

  // Attendance Service
  AttendanceService? get _attendanceService {
    try {
      return Get.find<AttendanceService>();
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
  final userAvatarUrl = ''.obs;

  // Current date info
  final currentDate = DateHelper.nowWib().obs;
  final workStatus = 'Working'.obs;
  final workStartTime = '08:00 AM'.obs;
  final workEndTime = '05:00 PM'.obs;

  // Location
  final LocationService _locationService = LocationService();
  final currentLocation = Rxn<LocationData>();
  final isLoadingLocation = false.obs;
  final locationError = ''.obs;

  // Attendance
  final todayAttendance = Rxn<AttendanceModel>();
  final isLoadingAttendance = false.obs;
  final isCheckingIn = false.obs;
  final isCheckingOut = false.obs;

  // Timer for updating UI
  Timer? _uiUpdateTimer;

  // Department list for supervisor
  final departments = <DepartmentModel>[].obs;
  final isLoadingDepartments = false.obs;

  // User's department (for member view)
  final userDepartment = Rxn<DepartmentModel>();

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
    _loadCurrentLocation();
    _loadTodayAttendance();
    _startUIUpdateTimer();
  }

  @override
  void onClose() {
    searchController.dispose();
    _uiUpdateTimer?.cancel();
    super.onClose();
  }

  /// Load current location with address
  Future<void> _loadCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = '';

      // Check and request permission first (this will show the prompt)
      final permissionStatus = await _locationService.checkAndRequestPermission();

      switch (permissionStatus) {
        case LocationPermissionStatus.granted:
          // Permission granted, get location
          final locationData = await _locationService.getLocationWithAddress();
          if (locationData != null) {
            currentLocation.value = locationData;
          } else {
            locationError.value = 'Unable to get location';
          }
          break;
        case LocationPermissionStatus.denied:
          locationError.value = 'Location permission denied';
          break;
        case LocationPermissionStatus.permanentlyDenied:
          locationError.value = 'Location permission permanently denied';
          break;
        case LocationPermissionStatus.serviceDisabled:
          locationError.value = 'Location services disabled';
          break;
      }
    } catch (e) {
      locationError.value = 'Location error: ${e.toString()}';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Refresh location (can be called from UI)
  Future<void> refreshLocation() async {
    await _loadCurrentLocation();
  }

  /// Get formatted location for display
  String get displayLocation {
    if (isLoadingLocation.value) {
      return 'Getting location...';
    }
    if (currentLocation.value != null) {
      return currentLocation.value!.shortAddress;
    }
    if (locationError.value.isNotEmpty) {
      return 'Tap to enable location';
    }
    return 'Getting location...';
  }

  /// Show location permission dialog
  void showLocationPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Please enable location permission to get your current address.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _locationService.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _loadUserData() {
    final authService = _authService;
    if (authService != null) {
      final user = authService.currentUser;
      if (user != null) {
        userName.value = user.displayName;
        userRole.value = user.role;
        userPosition.value = user.role;
        userAvatarUrl.value = user.avatarUrl; // Load avatar URL
        
        // Load departments if user is supervisor
        if (isSupervisor) {
          loadDepartments();
        }
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
        final response = await taskService.getMyTasksWithCustomerName();
 
        print('=== DASHBOARD TASK DEBUG ===');
        print('Response is null: ${response == null}');
        print('Response success: ${response?.success}');
        print('Total tasks from API: ${response?.data?.length ?? 0}');
        if (response?.data != null && response!.data.isNotEmpty) {
          print('Task statuses: ${response.data.map((t) => '${t.taskSubject}: status="${t.status}", isSubmitted=${t.isSubmitted}').toList()}');
        }
 
        if (response != null && response.success) {
          // Normalize status by removing underscores (in_progress -> in progress)
          final normalizeStatus = (String status) => status.toLowerCase().replaceAll('_', ' ');

          // Filter for tasks with in_progress status
          // NOTE: Removed !task.isSubmitted check because backend returns is_submitted=true for all tasks
          final inProgressTasks = response.data
              .where((task) => normalizeStatus(task.status) == 'in progress')
              .toList();

          // Convert to DashboardTaskItem and store full model
          final dashboardItems = <DashboardTaskItem>[];
          _taskModelMap.clear();
 
          for (final task in inProgressTasks) {
            // Skip tasks without taskId (shouldn't happen for my-assigned endpoint)
            if (task.taskId == null) continue;
              
            dashboardItems.add(DashboardTaskItem(
              id: task.taskId.toString(),
              title: task.taskSubject,
              dueDate: task.dueDate,
            ));
            _taskModelMap[task.taskId!] = task;
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
    await _loadTodayAttendance();
    if (isSupervisor) {
      await loadDepartments();
    }
  }

  /// Load today's attendance status
  Future<void> _loadTodayAttendance() async {
    final attendanceService = _attendanceService;
    if (attendanceService == null) return;

    try {
      isLoadingAttendance.value = true;
      final attendance = await attendanceService.getTodayAttendance();
      todayAttendance.value = attendance;
    } catch (e) {
      print('Error loading today attendance: $e');
    } finally {
      isLoadingAttendance.value = false;
    }
  }

  /// Start timer to update UI every minute (to enable check-out button when time comes)
  void _startUIUpdateTimer() {
    _uiUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // Force UI update to check canCheckOut status
      update();
    });
  }

  /// Check if user can check in (hasn't checked in yet today)
  bool get canCheckIn =>
      todayAttendance.value == null || !todayAttendance.value!.hasCheckedIn;

  /// Check if user can check out (has checked in but not checked out yet AND past work end time)
  bool get canCheckOut {
    if (todayAttendance.value == null ||
        !todayAttendance.value!.hasCheckedIn ||
        todayAttendance.value!.hasCheckedOut) {
      return false;
    }

    // Check if current time is past work end time
    final now = DateTime.now();
    final workEndHour = int.tryParse(workEndTime.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 17; // Default 5 PM
    final workEndDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      workEndHour,
      0,
    );

    // Can check out if current time is >= work end time
    return now.isAfter(workEndDateTime) ||
        now.isAtSameMomentAs(workEndDateTime);
  }

  /// Perform check-in with image
  Future<bool> performCheckIn(
    File imageFile, {
    double? latitude,
    double? longitude,
  }) async {
    final attendanceService = _attendanceService;
    if (attendanceService == null) return false;

    // Use provided location or fallback to current location
    final lat = latitude ?? currentLocation.value?.latitude;
    final long = longitude ?? currentLocation.value?.longitude;

    if (lat == null || long == null) {
      Get.snackbar(
        'Error',
        'Location not available. Please enable location.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    }

    try {
      isCheckingIn.value = true;

      final attendance = await attendanceService.checkIn(
        latitude: lat,
        longitude: long,
        imageFile: imageFile,
      );

      if (attendance != null) {
        todayAttendance.value = attendance;
        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    } finally {
      isCheckingIn.value = false;
    }
  }

  /// Perform check-out with image
  Future<bool> performCheckOut(
    File imageFile, {
    double? latitude,
    double? longitude,
  }) async {
    final attendanceService = _attendanceService;
    if (attendanceService == null) return false;

    // Use provided location or fallback to current location
    final lat = latitude ?? currentLocation.value?.latitude;
    final long = longitude ?? currentLocation.value?.longitude;

    if (lat == null || long == null) {
      Get.snackbar(
        'Error',
        'Location not available. Please enable location.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    }

    try {
      isCheckingOut.value = true;

      final attendance = await attendanceService.checkOut(
        latitude: lat,
        longitude: long,
        imageFile: imageFile,
      );

      if (attendance != null) {
        todayAttendance.value = attendance;
        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    } finally {
      isCheckingOut.value = false;
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

  void createNewDepartment() async {
    final result = await Get.toNamed(Routes.CREATE_DEPARTMENT);
    
    // Refresh departments list if department was created
    if (result == true) {
      loadDepartments();
    }
  }

  void seeMoreTasks() => NavigationController.navigateToTask();

  void openDepartment(DepartmentModel department) async {
    final result = await Get.toNamed(Routes.DEPARTMENT_DETAIL, arguments: department);
    
    // Refresh departments if data was changed (edit/delete)
    if (result == true) {
      loadDepartments();
    }
  }

  void clockIn() {
    Get.toNamed(Routes.TAKE_ATTENDANCE, arguments: {'type': 'check-in'})?.then((result) {
      if (result == true) {
        _loadTodayAttendance(); // Refresh attendance after check-in
      }
    });
  }

  void clockOut() {
    Get.toNamed(Routes.TAKE_ATTENDANCE, arguments: {'type': 'check-out'})?.then((result) {
      if (result == true) {
        _loadTodayAttendance(); // Refresh attendance after check-out
      }
    });
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
