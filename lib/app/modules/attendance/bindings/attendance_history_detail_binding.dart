import 'package:get/get.dart';
import '../controllers/attendance_history_detail_controller.dart';

class AttendanceHistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceHistoryDetailController>(
      () => AttendanceHistoryDetailController(),
    );
  }
}
