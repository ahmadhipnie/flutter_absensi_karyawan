import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final userRole = ''.obs;
  final userName = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;

  // For Member specific
  final department = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      userName.value = user.email.split('@')[0];
      email.value = user.email;
      userRole.value = user.role;
      department.value = user.role;
    }
  }

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}
