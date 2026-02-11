import 'package:get/get.dart';
import '../controllers/attendance_log_controller.dart';

class AttendanceLogBinding extends Bindings {
  @override
  void dependencies() {
    // Delete existing instance first if exists to avoid conflicts
    Get.delete<AttendanceLogController>();
    
    // Put new instance (will read arguments in onInit)
    Get.put(AttendanceLogController());
  }
}
