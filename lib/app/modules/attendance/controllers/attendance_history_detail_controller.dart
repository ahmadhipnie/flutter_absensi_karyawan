import 'package:get/get.dart';

class AttendanceHistoryDetailController extends GetxController {
  AttendanceHistoryDetailController();

  // Observables
  final RxString formattedDate = ''.obs;
  final RxString photoUrl = ''.obs;
  final RxString notes = ''.obs;
  final RxString location = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAttendanceData();
  }

  void _loadAttendanceData() {
    // Get data from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      formattedDate.value = args['date'] ?? _getCurrentDate();
      photoUrl.value = args['photoUrl'] ?? '';
      notes.value = args['notes'] ?? '';
      location.value = args['location'] ?? '';
    } else {
      formattedDate.value = _getCurrentDate();
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
