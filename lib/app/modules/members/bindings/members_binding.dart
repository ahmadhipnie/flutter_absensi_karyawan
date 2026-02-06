import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import '../controllers/members_controller.dart';

class MembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatService>(() => ChatService(), fenix: true);
    Get.lazyPut<MembersController>(() => MembersController());
  }
}
