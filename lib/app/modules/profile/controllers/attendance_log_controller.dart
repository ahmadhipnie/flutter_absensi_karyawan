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

  UserModel? get currentUser => _authService.currentUser;

  @override
  void onInit() {
    super.onInit();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    final user = currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;

      final firstDay = DateTime(selectedMonth.value.year, selectedMonth.value.month, 1);
      final lastDay = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0);

      final data = await _attendanceService.getMyAttendances(
        startDate: firstDay,
        endDate: lastDay,
      );

      // Filter just in case the service returned other users' data
      final filtered = data.where((a) => a.userId == user.id).toList();

      // Sort newest first
      filtered.sort((a, b) => b.date.compareTo(a.date));

      attendances.value = filtered;

      _calculateStats();
    } catch (e) {
      print('Error loading profile attendances: $e');
      attendances.clear();
      _calculateStats();
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStats() {
    presentDays.value = attendances.where((a) => a.hasCheckedIn).length;
    lateDays.value = attendances.where((a) => a.lateDuration > 0).length;
    absentDays.value = attendances.where((a) => a.status.toLowerCase() == 'absent' || (!a.hasCheckedIn && a.status.toLowerCase() != 'present')).length;
    totalDays.value = attendances.length;
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
    Get.toNamed(
      Routes.ATTENDANCE_HISTORY_DETAIL,
      arguments: {
        'employeeName': currentUser?.displayName ?? 'You',
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
}
