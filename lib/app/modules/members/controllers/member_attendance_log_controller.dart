import 'package:get/get.dart';
import '../../../data/services/attendance_service.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

class MemberAttendanceLogController extends GetxController {
  final UserModel user;
  MemberAttendanceLogController(this.user);

  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  final attendances = <AttendanceModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    try {
      isLoading.value = true;

      // Use getAttendancesByUser to fetch attendances for specific member
      final data = await _attendanceService.getAttendancesByUser(
        userId: user.id,
      );

      // Sort by date descending (newest first)
      data.sort((a, b) => b.date.compareTo(a.date));

      attendances.value = data;
    } catch (e) {
      print('Error loading member attendances: $e');
      attendances.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String formatLogDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void viewAttendanceDetail(AttendanceModel attendance) {
    Get.toNamed(
      Routes.ATTENDANCE_HISTORY_DETAIL,
      arguments: {
        'employeeName': user.displayName,
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
