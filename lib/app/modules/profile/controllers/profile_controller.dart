import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userRole = 'Supervisor'.obs; // Or 'Member', inherited from auth/dashboard
  final userName = 'Alsaa Cantikk'.obs;
  final email = 'alsaacantikk464@gmail.com'.obs;
  
  // For Member specific
  final department = 'UI/UX Designer'.obs;

  @override
  void onInit() {
    super.onInit();
    // TODO: Load real user data
  }
  
  void logout() {
    // TODO: Implement logout
    Get.offAllNamed('/splash');
  }
}
