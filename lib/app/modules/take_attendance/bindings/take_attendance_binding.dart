import 'package:get/get.dart';
import '../controllers/take_attendance_controller.dart';
import '../../attendance/controllers/attendance_controller.dart';

class TakeAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TakeAttendanceController>(() => TakeAttendanceController());

    // Register AttendanceController if not already registered
    if (!Get.isRegistered<AttendanceController>()) {
      Get.lazyPut<AttendanceController>(() => AttendanceController());
    }
  }
}
