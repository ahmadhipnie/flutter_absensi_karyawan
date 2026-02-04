import 'package:get/get.dart';
import '../controllers/take_attendance_controller.dart';

class TakeAttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TakeAttendanceController>(() => TakeAttendanceController());
  }
}
