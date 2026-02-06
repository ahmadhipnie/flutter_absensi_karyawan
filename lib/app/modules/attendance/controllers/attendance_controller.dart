import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/location_service.dart';
import '../../../routes/app_pages.dart';

class AttendanceController extends GetxController {
  final currentDate = DateTime.now().obs;
  final workStatus = 'Working'.obs;
  final workStartTime = '08:00'.obs;
  final workEndTime = '05:00'.obs;

  // Location
  final LocationService _locationService = LocationService();
  final currentLocation = Rxn<LocationData>();
  final isLoadingLocation = false.obs;
  final locationError = ''.obs;

  // Mock data for employees
  final employeesClockedIn = <EmployeeAttendance>[
    EmployeeAttendance(
      name: 'Karina',
      checkInTime: '08:00',
      avatarUrl: '', // Using default or asset later
      status: 'Check in on 08:00',
    ),
    EmployeeAttendance(
      name: 'Bambang',
      checkInTime: '08:00',
      avatarUrl: '',
      status: 'Check in on 08:00',
    ),
    EmployeeAttendance(
      name: 'Jessylin',
      checkInTime: '08:00',
      avatarUrl: '',
      status: 'Check in on 08:00',
    ),
    EmployeeAttendance(
      name: 'Basuki',
      checkInTime: '08:00',
      avatarUrl: '',
      status: 'Check in on 08:00',
    ),
  ].obs;

  final employeesNotClockedIn = <EmployeeAttendance>[].obs;

  final showClockedIn = true.obs;

  void updateWorkHours(String start, String end) {
    workStartTime.value = start;
    workEndTime.value = end;
  }

  void clockIn() {
    Get.toNamed(Routes.TAKE_ATTENDANCE);
  }

  void viewEmployeeHistory(EmployeeAttendance employee) {
    Get.toNamed(
      Routes.ATTENDANCE_HISTORY_DETAIL,
      arguments: {
        'employeeName': employee.name,
        'date': _getCurrentDate(),
        'checkInTime': employee.checkInTime,
        'photoUrl': employee.avatarUrl,
        'notes': 'Work from office',
        'location': displayLocation,
      },
    );
  }

  String _getCurrentDate() {
    final now = currentDate.value;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLocation();
  }

  /// Load current location with address
  Future<void> _loadCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = '';

      // Check and request permission first (this will show the prompt)
      final permissionStatus = await _locationService.checkAndRequestPermission();

      switch (permissionStatus) {
        case LocationPermissionStatus.granted:
          // Permission granted, get location
          final locationData = await _locationService.getLocationWithAddress();
          if (locationData != null) {
            currentLocation.value = locationData;
          } else {
            locationError.value = 'Unable to get location';
          }
          break;
        case LocationPermissionStatus.denied:
          locationError.value = 'Location permission denied';
          break;
        case LocationPermissionStatus.permanentlyDenied:
          locationError.value = 'Location permission permanently denied';
          break;
        case LocationPermissionStatus.serviceDisabled:
          locationError.value = 'Location services disabled';
          break;
      }
    } catch (e) {
      locationError.value = 'Location error: ${e.toString()}';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Refresh location (can be called from UI)
  Future<void> refreshLocation() async {
    await _loadCurrentLocation();
  }

  /// Get formatted location for display
  String get displayLocation {
    if (isLoadingLocation.value) {
      return 'Getting location...';
    }
    if (currentLocation.value != null) {
      return currentLocation.value!.shortAddress;
    }
    if (locationError.value.isNotEmpty) {
      return 'Tap to enable location';
    }
    return 'Getting location...';
  }

  /// Show location permission dialog
  void showLocationPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'Please enable location permission to get your current address.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _locationService.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

class EmployeeAttendance {
  final String name;
  final String checkInTime;
  final String avatarUrl;
  final String status;

  EmployeeAttendance({
    required this.name,
    required this.checkInTime,
    required this.avatarUrl,
    required this.status,
  });
}
