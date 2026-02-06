import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Model for location data with address
class LocationData {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? subLocality;
  final String? postalCode;
  final String? country;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.subLocality,
    this.postalCode,
    this.country,
    required this.timestamp,
  });

  /// Get formatted address for display
  String get displayAddress {
    if (address != null && address!.isNotEmpty) {
      return address!;
    }
    if (subLocality != null && city != null) {
      return '$subLocality, $city';
    }
    if (city != null) {
      return city!;
    }
    return '$latitude, $longitude';
  }

  /// Get short address (subLocality + city)
  String get shortAddress {
    if (subLocality != null && city != null) {
      return '$subLocality, $city';
    }
    if (city != null) {
      return city!;
    }
    return displayAddress;
  }

  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? subLocality,
    String? postalCode,
    String? country,
    DateTime? timestamp,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      subLocality: subLocality ?? this.subLocality,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Enum for location permission status
enum LocationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

/// Service for handling location and geocoding operations
class LocationService extends GetxService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permission
  /// Returns true if permission is granted
  Future<bool> requestLocationPermission() async {
    // Check current permission status
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      // Request permission
      status = await Permission.location.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // User has permanently denied permission
      return false;
    }

    return false;
  }

  /// Get current location permission status
  Future<PermissionStatus> getPermissionStatus() async {
    return await Permission.location.status;
  }

  /// Check location permission status and request if needed
  /// Returns detailed status for UI handling
  Future<LocationPermissionStatus> checkAndRequestPermission() async {
    // First check if location services are enabled
    final bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    // Check current permission status
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      return LocationPermissionStatus.granted;
    }

    if (status.isDenied) {
      // Request permission - this will show the system prompt
      status = await Permission.location.request();
      
      if (status.isGranted) {
        return LocationPermissionStatus.granted;
      } else if (status.isPermanentlyDenied) {
        return LocationPermissionStatus.permanentlyDenied;
      } else {
        return LocationPermissionStatus.denied;
      }
    }

    if (status.isPermanentlyDenied) {
      return LocationPermissionStatus.permanentlyDenied;
    }

    return LocationPermissionStatus.denied;
  }

  /// Get current position with high accuracy
  /// Returns null if permission is denied or location services are disabled
  Future<Position?> getCurrentPosition() async {
    try {
      // Check and request permission first
      final permissionStatus = await checkAndRequestPermission();
      
      if (permissionStatus != LocationPermissionStatus.granted) {
        return null;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  /// Get location data with reverse geocoding (address)
  Future<LocationData?> getLocationWithAddress() async {
    final Position? position = await getCurrentPosition();
    if (position == null) {
      return null;
    }

    try {
      // Perform reverse geocoding
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        // Return location without address
        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now(),
        );
      }

      final Placemark place = placemarks.first;

      // Build full address
      final List<String> addressParts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
      ].where((part) => part != null && part.isNotEmpty).cast<String>().toList();

      final String fullAddress = addressParts.join(', ');

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: fullAddress.isNotEmpty ? fullAddress : null,
        city: place.locality,
        subLocality: place.subLocality,
        postalCode: place.postalCode,
        country: place.country,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      // Return location without address if geocoding fails
      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Get address from coordinates (reverse geocoding)
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }

      final Placemark place = placemarks.first;

      final List<String> addressParts = [
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
      ].where((part) => part != null && part.isNotEmpty).cast<String>().toList();

      return addressParts.join(', ');
    } catch (e) {
      return null;
    }
  }

  /// Get distance between two positions in meters
  double getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Check if user is within a certain radius of a target location
  bool isWithinRadius(
    double userLat,
    double userLng,
    double targetLat,
    double targetLng,
    double radiusInMeters,
  ) {
    final double distance = getDistanceBetween(userLat, userLng, targetLat, targetLng);
    return distance <= radiusInMeters;
  }

  /// Open app settings to enable location permission
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Open location settings to enable GPS
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
