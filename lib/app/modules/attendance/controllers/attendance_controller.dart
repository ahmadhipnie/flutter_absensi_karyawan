import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:async';
import '../../../data/services/location_service.dart';
import '../../../data/services/attendance_service.dart';
import '../../../data/models/attendance_model.dart';
import '../../../routes/app_pages.dart';

class AttendanceController extends GetxController {
  final currentDate = DateTime.now().obs;
  final workStatus = 'Working'.obs;
  final workStartTime = '08:00'.obs;
  final workEndTime = '05:00'.obs;

  // Services
  final LocationService _locationService = LocationService();
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  // Location
  final currentLocation = Rxn<LocationData>();
  final isLoadingLocation = false.obs;
  final locationError = ''.obs;

  // Attendance
  final todayAttendance = Rxn<AttendanceModel>();
  final isLoadingAttendance = false.obs;
  final isCheckingIn = false.obs;
  final isCheckingOut = false.obs;

  // Timer for updating UI
  Timer? _uiUpdateTimer;

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
    Get.toNamed(Routes.TAKE_ATTENDANCE, arguments: {'type': 'check-in'})?.then((
      result,
    ) {
      if (result == true) {
        _loadTodayAttendance(); // Refresh attendance after check-in
      }
    });
  }

  void clockOut() {
    Get.toNamed(Routes.TAKE_ATTENDANCE, arguments: {'type': 'check-out'})?.then(
      (result) {
        if (result == true) {
          _loadTodayAttendance(); // Refresh attendance after check-out
        }
      },
    );
  }

  /// Perform check-in with image
  Future<bool> performCheckIn(
    File imageFile, {
    double? latitude,
    double? longitude,
  }) async {
    // Use provided location or fallback to current location
    final lat = latitude ?? currentLocation.value?.latitude;
    final long = longitude ?? currentLocation.value?.longitude;

    if (lat == null || long == null) {
      Get.snackbar(
        'Error',
        'Location not available. Please enable location.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    }

    try {
      print('performCheckIn: Starting check-in...');
      isCheckingIn.value = true;

      final attendance = await _attendanceService.checkIn(
        latitude: lat,
        longitude: long,
        imageFile: imageFile,
      );

      print('performCheckIn: attendance result: $attendance');

      if (attendance != null) {
        print(
          'performCheckIn: Setting todayAttendance (not showing snackbar here)',
        );
        todayAttendance.value = attendance;
        // Don't show snackbar here, let the caller handle it
        print('performCheckIn: Returning true');
        return true;
      }

      print('performCheckIn: attendance is null, returning false');
      return false;
    } catch (e) {
      print('performCheckIn: Error caught: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    } finally {
      isCheckingIn.value = false;
      print('performCheckIn: isCheckingIn set to false');
    }
  }

  /// Perform check-out with image
  Future<bool> performCheckOut(
    File imageFile, {
    double? latitude,
    double? longitude,
  }) async {
    // Use provided location or fallback to current location
    final lat = latitude ?? currentLocation.value?.latitude;
    final long = longitude ?? currentLocation.value?.longitude;

    if (lat == null || long == null) {
      Get.snackbar(
        'Error',
        'Location not available. Please enable location.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    }

    try {
      isCheckingOut.value = true;

      final attendance = await _attendanceService.checkOut(
        latitude: lat,
        longitude: long,
        imageFile: imageFile,
      );

      if (attendance != null) {
        todayAttendance.value = attendance;
        // Don't show snackbar here, let the caller handle it
        return true;
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return false;
    } finally {
      isCheckingOut.value = false;
    }
  }

  /// Check if user can check in (hasn't checked in yet today)
  bool get canCheckIn =>
      todayAttendance.value == null || !todayAttendance.value!.hasCheckedIn;

  /// Check if user can check out (has checked in but not checked out yet AND past work end time)
  bool get canCheckOut {
    if (todayAttendance.value == null ||
        !todayAttendance.value!.hasCheckedIn ||
        todayAttendance.value!.hasCheckedOut) {
      return false;
    }

    // Check if current time is past work end time
    final now = DateTime.now();
    final workEndHour = int.tryParse(workEndTime.value) ?? 17; // Default 5 PM
    final workEndDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      workEndHour,
      0,
    );

    // Can check out if current time is >= work end time
    return now.isAfter(workEndDateTime) ||
        now.isAtSameMomentAs(workEndDateTime);
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLocation();
    _loadTodayAttendance();
    _startUIUpdateTimer();
  }

  @override
  void onClose() {
    _uiUpdateTimer?.cancel();
    super.onClose();
  }

  /// Start timer to update UI every minute (to enable check-out button when time comes)
  void _startUIUpdateTimer() {
    _uiUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // Force UI update to check canCheckOut status
      update();
    });
  }

  /// Load today's attendance status
  Future<void> _loadTodayAttendance() async {
    try {
      isLoadingAttendance.value = true;
      final attendance = await _attendanceService.getTodayAttendance();
      todayAttendance.value = attendance;
    } catch (e) {
      print('Error loading today attendance: $e');
    } finally {
      isLoadingAttendance.value = false;
    }
  }

  /// Load current location with address
  Future<void> _loadCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = '';

      // Check and request permission first (this will show the prompt)
      final permissionStatus = await _locationService
          .checkAndRequestPermission();

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
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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
