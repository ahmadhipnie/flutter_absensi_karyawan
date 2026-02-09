import 'package:get/get.dart';
import '../controllers/attendance_log_controller.dart';

class AttendanceLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceLogController());
  }
}
