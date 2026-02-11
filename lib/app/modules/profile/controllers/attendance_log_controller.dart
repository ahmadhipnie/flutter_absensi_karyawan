import 'dart:async';
import 'package:get/get.dart';
import '../../../data/services/attendance_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

class AttendanceLogController extends GetxController {
  final AttendanceService _attendanceService = Get.find<AttendanceService>();
  final AuthService _authService = Get.find<AuthService>();

  final selectedMonth = DateTime.now().obs;

  final attendances = <AttendanceModel>[].obs;
  final isLoading = false.obs;

  final presentDays = 0.obs;
  final lateDays = 0.obs;
  final absentDays = 0.obs;
  final totalDays = 0.obs;

  // User whose attendance is being viewed (default: current user)
  UserModel? _viewingUser;

  UserModel? get currentUser => _authService.currentUser;

  /// Get the user whose attendance is being displayed
  UserModel? get viewingUser => _viewingUser ?? currentUser;

  /// Set a specific user to view their attendance (for supervisor view)
  void setViewingUser(UserModel? user) {
    _viewingUser = user;
    // Reload data with the new user
    _loadAttendances();
  }

  @override
  void onInit() {
    super.onInit();
    // Check if a specific user was passed in arguments
    try {
      final args = Get.arguments;
      if (args != null && args is Map && args['user'] is UserModel) {
        _viewingUser = args['user'] as UserModel;
        print('AttendanceLogController: Viewing user set to ${_viewingUser?.displayName}');
      }
    } catch (e) {
      print('Error reading arguments: $e');
    }
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    final user = viewingUser;
    if (user == null) {
      print('AttendanceLogController: No user available to load attendances');
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      final firstDay = DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);
      final lastDay = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0, 23, 59, 59);

      print('=== Loading Attendances for User: ${user.displayName} (ID: ${user.id}) ===');
      print('Date Range: $firstDay to $lastDay');

      List<AttendanceModel> data;
      
      // Check if viewing own attendance or someone else's
      final currentUserId = currentUser?.id;
      final isViewingOwnAttendance = currentUserId != null && currentUserId == user.id;
      
      if (isViewingOwnAttendance) {
        // Use /attendances/my endpoint (faster and more reliable)
        print('📊 Fetching own attendance via /attendances/my');
        data = await _attendanceService.getMyAttendances(
          startDate: firstDay,
          endDate: lastDay,
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            print('⚠️ getMyAttendances timeout after 15 seconds');
            return <AttendanceModel>[];
          },
        );
      } else {
        // Viewing someone else's attendance (supervisor view)
        // Use /attendances endpoint and filter
        print('📊 Fetching all attendances and filtering for user ${user.id}');
        data = await _attendanceService.getAllAttendances().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            print('⚠️ getAllAttendances timeout after 15 seconds');
            return <AttendanceModel>[];
          },
        );
        
        // Filter by user ID and date range
        data = data.where((attendance) {
          // Filter by user
          if (attendance.userId != user.id) return false;
          
          // Filter by date range
          final attendanceDate = DateTime(
            attendance.date.year,
            attendance.date.month,
            attendance.date.day,
          );
          final start = DateTime(firstDay.year, firstDay.month, firstDay.day);
          final end = DateTime(lastDay.year, lastDay.month, lastDay.day);
          
          return (attendanceDate.isAfter(start) || attendanceDate.isAtSameMomentAs(start)) &&
                 (attendanceDate.isBefore(end) || attendanceDate.isAtSameMomentAs(end));
        }).toList();
        
        print('📊 Filtered to ${data.length} records for user ${user.id}');
      }

      print('✅ Total records fetched: ${data.length}');

      // Sort newest first
      if (data.isNotEmpty) {
        data.sort((a, b) => b.date.compareTo(a.date));
      }

      attendances.value = data;

      _calculateStats();
      
      // Show message if no data
      if (data.isEmpty) {
        Get.snackbar(
          'Info',
          'No attendance records found for ${user.displayName} in $formattedMonth',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Get.theme.colorScheme.surface,
        );
      }
    } on TimeoutException catch (e) {
      print('⏱️ Timeout error: $e');
      attendances.clear();
      _calculateStats();
      
      // Show timeout specific error
      Get.snackbar(
        'Timeout',
        'Request took too long. Please check your connection.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
    } catch (e, stackTrace) {
      print('❌ Error loading attendances: $e');
      print('Stack trace: $stackTrace');
      attendances.clear();
      _calculateStats();
      
      // Show error to user
      Get.snackbar(
        'Error',
        'Failed to load attendance data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Get.theme.colorScheme.errorContainer,
      );
    } finally {
      isLoading.value = false;
      print('🏁 Loading completed. isLoading = false');
    }
  }

  void _calculateStats() {
    try {
      presentDays.value = attendances.where((a) => a.hasCheckedIn).length;
      lateDays.value = attendances.where((a) => a.lateDuration > 0).length;
      absentDays.value = attendances.where((a) => 
        a.status.toLowerCase() == 'absent' || 
        (!a.hasCheckedIn && a.status.toLowerCase() != 'present')
      ).length;
      totalDays.value = attendances.length;
      
      print('Stats calculated: Present=${ presentDays.value}, Late=${lateDays.value}, Absent=${absentDays.value}, Total=${totalDays.value}');
    } catch (e) {
      print('Error calculating stats: $e');
      // Reset to zero on error
      presentDays.value = 0;
      lateDays.value = 0;
      absentDays.value = 0;
      totalDays.value = 0;
    }
  }

  Future<void> previousMonth() async {
    selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month - 1);
    await _loadAttendances();
  }

  Future<void> nextMonth() async {
    selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1);
    await _loadAttendances();
  }

  String get formattedMonth {
    const months = [
      'January','February','March','April','May','June','July','August','September','October','November','December'
    ];
    return '${months[selectedMonth.value.month - 1]} ${selectedMonth.value.year}';
  }

  String formatLogDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void viewAttendanceDetail(AttendanceModel attendance) {
    final user = viewingUser;
    Get.toNamed(
      Routes.ATTENDANCE_HISTORY_DETAIL,
      arguments: {
        'employeeName': user?.displayName ?? 'You',
        'date': formatLogDate(attendance.date),
        'checkInTime': attendance.clockInTime,
        'checkOutTime': attendance.clockOutTime,
        'photoUrl': attendance.clockInImage ?? attendance.clockOutImage ?? '',
        'notes': attendance.status,
        'location': attendance.clockInLat != null && attendance.clockInLong != null
            ? '${attendance.clockInLat}, ${attendance.clockInLong}'
            : (attendance.clockOutLat != null && attendance.clockOutLong != null
                ? '${attendance.clockOutLat}, ${attendance.clockOutLong}'
                : 'N/A'),
      },
    );
  }

  Future<void> refresh() async {
    await _loadAttendances();
  }

  @override
  void onClose() {
    print('AttendanceLogController: Disposing');
    super.onClose();
  }
}
