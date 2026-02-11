import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../data/services/location_service.dart';
import '../../attendance/controllers/attendance_controller.dart';

class TakeAttendanceController extends GetxController {
  // Selected date
  final selectedDate = DateTime.now().obs;

  // Photo
  final ImagePicker _imagePicker = ImagePicker();
  final photoFile = Rxn<File>();
  final hasPhoto = false.obs;

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

  // Type of attendance: 'check-in' or 'check-out'
  String attendanceType = 'check-in';

  // Submitting state
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get attendance type from arguments
    final args = Get.arguments;
    if (args != null && args['type'] != null) {
      attendanceType = args['type'];
    }

    _loadCurrentLocation();
  }

  /// Load current location with address
  Future<void> _loadCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      locationError.value = '';

      // Check and request permission first
      final permissionStatus = await _locationService
          .checkAndRequestPermission();

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

  /// Take photo using camera only (no gallery)
  /// Automatically compress if image exceeds 5MB
  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (photo == null) return;

      File imageFile = File(photo.path);
      int fileSize = await imageFile.length();

      // Check if image exceeds 5MB (5 * 1024 * 1024 bytes)
      const int maxSize = 5 * 1024 * 1024;

      if (fileSize > maxSize) {
        Get.snackbar(
          'Compressing',
          'Image size is ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB, compressing...',
          duration: const Duration(seconds: 2),
        );

        // Compress the image
        imageFile = await _compressImage(imageFile);

        // Verify compression result
        fileSize = await imageFile.length();
        if (fileSize > maxSize) {
          Get.snackbar(
            'Warning',
            'Image still exceeds 5MB after compression. Please retake with lower quality.',
            duration: const Duration(seconds: 3),
          );
        }
      }

      photoFile.value = imageFile;
      hasPhoto.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture photo: ${e.toString()}');
    }
  }

  /// Compress image to reduce file size
  /// Target size: under 5MB
  Future<File> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Compress with aggressive settings for large files
      final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 60, // Lower quality for better compression
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      if (compressed != null) {
        final compressedFile = File(compressed.path);
        final originalSize = await file.length();
        final compressedSize = await compressedFile.length();

        print(
          'Photo compressed: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB → ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        return compressedFile;
      }

      // If compression fails, return original
      return file;
    } catch (e) {
      print('Compression error: $e');
      return file;
    }
  }

  /// Retake photo (clear current and open camera)
  Future<void> retakePhoto() async {
    await takePhoto();
  }

  /// Clear photo
  void clearPhoto() {
    photoFile.value = null;
    hasPhoto.value = false;
  }

  /// Clock in action
  Future<void> clockIn() async {
    // Prevent multiple submissions
    if (isSubmitting.value) {
      print('clockIn: Already submitting, ignoring duplicate call');
      return;
    }

    // Validate photo
    if (!hasPhoto.value || photoFile.value == null) {
      Get.snackbar('Error', 'Please take a photo first');
      return;
    }

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
      Get.snackbar(
        'Error',
        'Location coordinates not available. Please refresh location.',
      );
      return;
    }

    try {
      print('clockIn: Starting submission...');
      isSubmitting.value = true;

      // Get attendance controller
      final attendanceController = Get.find<AttendanceController>();

      bool success = false;
      if (attendanceType == 'check-in') {
        print('clockIn: Type is check-in');
        // Check if already checked in
        if (attendanceController.todayAttendance.value?.hasCheckedIn == true) {
          print('clockIn: Already checked in, showing info and closing');
          Get.snackbar(
            'Info',
            'You have already checked in today',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange[100],
          );
          // Close the page
          Get.back();
          return;
        }

        print(
          'clockIn: Calling performCheckIn with lat: $latitude, long: $longitude',
        );
        success = await attendanceController.performCheckIn(
          photoFile.value!,
          latitude: latitude,
          longitude: longitude,
        );
        print('clockIn: performCheckIn returned: $success');
      } else {
        print('clockIn: Type is check-out');
        // Check if already checked out
        if (attendanceController.todayAttendance.value?.hasCheckedOut == true) {
          print('clockIn: Already checked out, showing info and closing');
          Get.snackbar(
            'Info',
            'You have already checked out today',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange[100],
          );
          // Close the page
          Get.back();
          return;
        }

        print(
          'clockIn: Calling performCheckOut with lat: $latitude, long: $longitude',
        );
        success = await attendanceController.performCheckOut(
          photoFile.value!,
          latitude: latitude,
          longitude: longitude,
        );
        print('clockIn: performCheckOut returned: $success');
      }

      if (success) {
        print('clockIn: Success! Closing page...');

        // Close the page immediately and return success
        Get.back(result: true);
        print('clockIn: Get.back() called');

        // Show success message on the previous page after a short delay
        await Future.delayed(const Duration(milliseconds: 300));
        final message = attendanceType == 'check-in'
            ? 'Check-in successful!'
            : 'Check-out successful!';

        Get.snackbar(
          'Success',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
      } else {
        print('clockIn: Failed! Success was false');
        Get.snackbar(
          'Error',
          'Failed to submit attendance. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
        );
      }
    } catch (e) {
      print('clockIn: Exception caught: $e');
      Get.snackbar(
        'Error',
        'Failed to submit attendance: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isSubmitting.value = false;
      print('clockIn: isSubmitting set to false in finally');
    }
  }

  /// Get button text based on attendance type
  String get buttonText {
    return attendanceType == 'check-in' ? 'Clock In' : 'Clock Out';
  }

  /// Get title based on attendance type
  String get title {
    return attendanceType == 'check-in' ? 'Check In' : 'Check Out';
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
