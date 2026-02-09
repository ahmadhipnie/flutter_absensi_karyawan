import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../data/services/location_service.dart';

class AttendanceHistoryDetailController extends GetxController {
  AttendanceHistoryDetailController();

  // Observables
  final RxString formattedDate = ''.obs;
  final RxString photoUrl = ''.obs;
  final RxString notes = ''.obs;
  final RxString location = ''.obs;

  // Services
  final LocationService _locationService = LocationService();

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

      final rawPhoto = args['photoUrl'] ?? '';
      final fullPhoto = AppConfig.getAttendancePhotoUrl(rawPhoto as String?);
      photoUrl.value = fullPhoto ?? '';

      notes.value = (args['notes'] as String?)?.isNotEmpty == true
          ? args['notes'] as String
          : 'No notes available';

      final loc = args['location'] as String?;

      // If location looks like coordinates (lat, long), try reverse geocoding
      if (loc != null && loc.isNotEmpty && loc.contains(',')) {
        final parts = loc.split(',');
        if (parts.length >= 2) {
          final latStr = parts[0].trim();
          final lngStr = parts[1].trim();
          final lat = double.tryParse(latStr);
          final lng = double.tryParse(lngStr);

          if (lat != null && lng != null) {
            // perform reverse geocoding asynchronously
            _locationService.getAddressFromCoordinates(lat, lng).then((addr) {
              if (addr != null && addr.isNotEmpty) {
                location.value = addr;
              } else {
                location.value = '$lat, $lng';
              }
            }).catchError((e) {
              location.value = '$lat, $lng';
            });
          } else {
            location.value = loc;
          }
        } else {
          location.value = loc;
        }
      } else {
        location.value = (loc != null && loc.isNotEmpty) ? loc : 'N/A';
      }
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
