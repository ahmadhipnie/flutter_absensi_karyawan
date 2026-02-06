import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/location_service.dart';

class TakeAttendanceController extends GetxController {
  // Selected date
  final selectedDate = DateTime.now().obs;

  // Photo path (using placeholder for UI)
  final photoPath = ''.obs;
  final hasPhoto = true.obs;

  // Form fields
  final notesController = TextEditingController(text: 'Work');
  final locationController = TextEditingController();

  // Location
  final LocationService _locationService = LocationService();
  final currentLocation = Rxn<LocationData>();
  final isLoadingLocation = false.obs;
  final locationError = ''.obs;
  
  // Coordinates for API submission
  double? latitude;
  double? longitude;

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

      // Check and request permission first
      final permissionStatus = await _locationService.checkAndRequestPermission();

      switch (permissionStatus) {
        case LocationPermissionStatus.granted:
          // Permission granted, get location
          final locationData = await _locationService.getLocationWithAddress();
          if (locationData != null) {
            currentLocation.value = locationData;
            latitude = locationData.latitude;
            longitude = locationData.longitude;
            locationController.text = locationData.displayAddress;
          } else {
            locationError.value = 'Unable to get location';
            _setDefaultLocation();
          }
          break;
        case LocationPermissionStatus.denied:
          locationError.value = 'Location permission denied';
          _setDefaultLocation();
          break;
        case LocationPermissionStatus.permanentlyDenied:
          locationError.value = 'Location permission permanently denied';
          _setDefaultLocation();
          break;
        case LocationPermissionStatus.serviceDisabled:
          locationError.value = 'Location services disabled';
          _setDefaultLocation();
          break;
      }
    } catch (e) {
      locationError.value = 'Location error: ${e.toString()}';
      _setDefaultLocation();
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Set default location when permission is denied
  void _setDefaultLocation() {
    locationController.text = 'Location unavailable - Tap to retry';
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
      return currentLocation.value!.displayAddress;
    }
    return locationController.text;
  }

  /// Format date for app bar title
  String get formattedDate {
    final date = selectedDate.value;
    final months = [
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Retake photo
  void retakePhoto() {
    // TODO: Implement camera functionality
    Get.snackbar('Camera', 'Opening camera...');
  }

  /// Clock in action
  void clockIn() {
    if (notesController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please add notes');
      return;
    }
    if (locationController.text.trim().isEmpty ||
        locationController.text == 'Location unavailable - Tap to retry') {
      Get.snackbar('Error', 'Please enable location permission');
      return;
    }
    
    // Check if we have coordinates
    if (latitude == null || longitude == null) {
      Get.snackbar('Error', 'Location coordinates not available. Please refresh location.');
      return;
    }
    
    // TODO: Submit attendance to backend with:
    // - latitude: $latitude
    // - longitude: $longitude
    // - address: ${locationController.text}
    // - notes: ${notesController.text}
    // - timestamp: ${DateTime.now().toIso8601String()}
    
    Get.snackbar(
      'Success',
      'Clock in successful at:\n${locationController.text}\nLat: ${latitude!.toStringAsFixed(6)}, Lng: ${longitude!.toStringAsFixed(6)}',
      duration: const Duration(seconds: 4),
    );
  }

  /// Get location data for API submission
  Map<String, dynamic>? getLocationDataForApi() {
    if (latitude == null || longitude == null) {
      return null;
    }
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': locationController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  @override
  void onClose() {
    notesController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
