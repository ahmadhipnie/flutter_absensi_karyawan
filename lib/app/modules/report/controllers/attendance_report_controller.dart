import 'package:get/get.dart';

class AttendanceReportController extends GetxController {
  final selectedEmployee = 'Alsaa Cantikk'.obs;
  final selectedMonth = 'February 2026'.obs;

  final stats = {
    'Absent': '19',
    'Clock In': '10',
    'Late Clock In': '20',
  }.obs;

  final logs = [
    {'date': '17 Feb 2026', 'time': '08:00'},
    {'date': '18 Feb 2026', 'time': '08:00'},
    {'date': '19 Feb 2026', 'time': '08:00'},
    {'date': '20 Feb 2026', 'time': '08:00'},
  ].obs;

  void onEmployeeChanged(String? newValue) {
    if (newValue != null) {
      selectedEmployee.value = newValue;
    }
  }

  void onMonthChanged(String? newValue) {
    if (newValue != null) {
      selectedMonth.value = newValue;
    }
  }
}
