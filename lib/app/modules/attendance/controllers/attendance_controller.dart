import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class AttendanceController extends GetxController {
  final currentDate = DateTime.now().obs;
  final workStatus = 'Working'.obs;
  final workStartTime = '08:00'.obs;
  final workEndTime = '05:00'.obs;
  final workLocation =
      'Jl. Orchard Boulevard, Belian, Kec. Batam Kota, Kota Batam, Kepulauan Riau 29464'
          .obs;

  // Mock data for employees
  final employeesClockedIn = <EmployeeAttendance>[
    EmployeeAttendance(
      name: 'Karina',
      checkInTime: '08:00',
      avatarUrl: '', // Using default or asset later
      status: 'Check in on 08:00',
    ),
    EmployeeAttendance(
      name: 'Bambang',
      checkInTime: '08:00',
      avatarUrl: '',
      status: 'Check in on 08:00',
    ),
    EmployeeAttendance(
      name: 'Jessylin',
      checkInTime: '08:00',
      avatarUrl: '',
      status: 'Check in on 08:00',
    ),
    EmployeeAttendance(
      name: 'Basuki',
      checkInTime: '08:00',
      avatarUrl: '',
      status: 'Check in on 08:00',
    ),
  ].obs;

  final employeesNotClockedIn = <EmployeeAttendance>[].obs;

  final showClockedIn = true.obs;

  void updateWorkHours(String start, String end) {
    workStartTime.value = start;
    workEndTime.value = end;
  }

  void clockIn() {
    Get.toNamed(Routes.TAKE_ATTENDANCE);
  }

  void viewEmployeeHistory(EmployeeAttendance employee) {
    Get.toNamed(
      Routes.ATTENDANCE_HISTORY_DETAIL,
      arguments: {
        'employeeName': employee.name,
        'date': _getCurrentDate(),
        'checkInTime': employee.checkInTime,
        'photoUrl': employee.avatarUrl,
        'notes': 'Work from office',
        'location': workLocation.value,
      },
    );
  }

  String _getCurrentDate() {
    final now = currentDate.value;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class EmployeeAttendance {
  final String name;
  final String checkInTime;
  final String avatarUrl;
  final String status;

  EmployeeAttendance({
    required this.name,
    required this.checkInTime,
    required this.avatarUrl,
    required this.status,
  });
}
