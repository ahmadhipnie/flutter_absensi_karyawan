import 'package:get/get.dart';
import '../controllers/select_member_controller.dart';

class SelectMemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectMemberController>(() => SelectMemberController());
  }
}
