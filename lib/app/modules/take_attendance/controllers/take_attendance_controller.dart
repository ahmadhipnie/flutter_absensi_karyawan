import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../data/services/location_service.dart';

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
        
        print('Photo compressed: ${(originalSize / 1024 / 1024).toStringAsFixed(2)} MB → ${(compressedSize / 1024 / 1024).toStringAsFixed(2)} MB');
        
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
      Get.snackbar('Error', 'Location coordinates not available. Please refresh location.');
      return;
    }
    
    // Get photo size for logging
    final photoSize = await photoFile.value!.length();
    final photoSizeMB = (photoSize / (1024 * 1024)).toStringAsFixed(2);
    
    // TODO: Submit attendance to backend with:
    // - photo: photoFile.value (multipart upload)
    // - latitude: $latitude
    // - longitude: $longitude
    // - address: ${locationController.text}
    // - notes: ${notesController.text}
    // - timestamp: ${DateTime.now().toIso8601String()}
    
    Get.snackbar(
      'Success',
      'Clock in successful!\nPhoto: ${photoSizeMB}MB, Location: ${locationController.text}',
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
