import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/attendance_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/attendance_model.dart';
import '../../../routes/app_pages.dart';

class AttendanceReportController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  // User selection
  final allUsers = <UserModel>[].obs;
  final selectedUser = Rxn<UserModel>();
  final isLoadingUsers = false.obs;

  // Date selection
  final selectedMonth = DateTime.now().obs;

  // Attendance data
  final attendances = <AttendanceModel>[].obs;
  final isLoadingAttendances = false.obs;

  // Statistics
  final totalDays = 0.obs;
  final presentDays = 0.obs;
  final lateDays = 0.obs;
  final absentDays = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsers();
  }

  /// Load all users (members only)
  Future<void> _loadUsers() async {
    try {
      isLoadingUsers.value = true;
      final users = await _userService.getUsers();
      
      // Filter only members
      allUsers.value = users.where((user) => user.role.toLowerCase() == 'member').toList();
      
      // Auto-select first user if available
      if (allUsers.isNotEmpty) {
        selectedUser.value = allUsers.first;
        await _loadAttendances();
      }
    } catch (e) {
      print('Error loading users: $e');
      Get.snackbar(
        'Error',
        'Failed to load employees: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingUsers.value = false;
    }
  }

  /// Load attendances for selected user and month
  Future<void> _loadAttendances() async {
    if (selectedUser.value == null) return;

    try {
      isLoadingAttendances.value = true;
      
      // Get first and last day of selected month
      final firstDay = DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);
      final lastDay = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);
      
      print('=== LOADING ATTENDANCES ===');
      print('Selected User: ${selectedUser.value!.displayName} (ID: ${selectedUser.value!.id})');
      print('Selected Month: ${formattedMonth}');
      print('Date Range: $firstDay to $lastDay');
      
      // Fetch attendances
      final data = await _attendanceService.getAttendancesByUser(
        userId: selectedUser.value!.id,
        startDate: firstDay,
        endDate: lastDay,
      );
      
      print('Received ${data.length} attendance records');
      
      // Sort by date descending (most recent first)
      data.sort((a, b) => b.date.compareTo(a.date));
      
      attendances.value = data;
      _calculateStats();
      
      print('Stats - Present: ${presentDays.value}, Absent: ${absentDays.value}, Late: ${lateDays.value}');
    } catch (e) {
      print('Error loading attendances: $e');
      Get.snackbar(
        'Error',
        'Failed to load attendance data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingAttendances.value = false;
    }
  }

  /// Calculate statistics from attendance data
  void _calculateStats() {
    // Count present days (has checked in)
    presentDays.value = attendances.where((a) => a.hasCheckedIn).length;
    
    // Count late days (late_duration > 0)
    lateDays.value = attendances.where((a) => a.lateDuration > 0).length;
    
    // Count absent days - only count explicit absent records from the data
    // Don't assume every day in the month should have attendance
    absentDays.value = attendances.where((a) => 
      a.status.toLowerCase() == 'absent' || 
      (!a.hasCheckedIn && a.status.toLowerCase() != 'present')
    ).length;
    
    // Get total working days (days with any attendance record)
    totalDays.value = attendances.length;
  }

  /// Handle employee selection
  Future<void> onEmployeeSelected(UserModel? user) async {
    if (user != null && user.id != selectedUser.value?.id) {
      selectedUser.value = user;
      await _loadAttendances();
    }
  }

  /// Handle month selection
  Future<void> onMonthSelected(DateTime month) async {
    if (month != selectedMonth.value) {
      selectedMonth.value = month;
      await _loadAttendances();
    }
  }

  /// Navigate to previous month
  Future<void> previousMonth() async {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
    await _loadAttendances();
  }

  /// Navigate to next month
  Future<void> nextMonth() async {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    await _loadAttendances();
  }

  /// Get formatted month string
  String get formattedMonth {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[selectedMonth.value.month - 1]} ${selectedMonth.value.year}';
  }

  /// Get formatted date for log entry
  String formatLogDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Navigate to attendance detail
  void viewAttendanceDetail(AttendanceModel attendance) {
    // Prefer clock-in coordinates, fallback to clock-out
    String location = 'N/A';
    if (attendance.clockInLat != null && attendance.clockInLong != null) {
      location = '${attendance.clockInLat}, ${attendance.clockInLong}';
    } else if (attendance.clockOutLat != null && attendance.clockOutLong != null) {
      location = '${attendance.clockOutLat}, ${attendance.clockOutLong}';
    }

    Get.toNamed(
      Routes.ATTENDANCE_HISTORY_DETAIL,
      arguments: {
        'employeeName': selectedUser.value?.displayName ?? 'Unknown',
        'date': formatLogDate(attendance.date),
        'checkInTime': attendance.clockInTime,
        'checkOutTime': attendance.clockOutTime,
        'photoUrl': attendance.clockInImage ?? attendance.clockOutImage ?? '',
        'notes': attendance.status,
        'location': location,
      },
    );
  }

  /// Refresh all data
  Future<void> refresh() async {
    await _loadAttendances();
  }
}
