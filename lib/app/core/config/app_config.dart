import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> loadEnv() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // If .env file is not found, throw a clear error
      throw Exception(
        '.env file not found. Please create a .env file with API_BASE_URL.\n'
        'Error: $e',
      );
    }
  }

  static String get apiBaseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_BASE_URL is not set in .env file');
    }
    // Remove trailing slash to avoid double slashes
    return url.replaceAll(RegExp(r'/+$'), '');
  }

  // Helper to build URL path without double slashes
  static String _buildUrl(String path) {
    final baseUrl = apiBaseUrl;
    final cleanPath = path.replaceAll(RegExp(r'^/+'), '');
    return '$baseUrl/$cleanPath';
  }

  static String? getDepartmentPhotoUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return _buildUrl('assets/departments_photo/$filename');
  }

  static String? getProfilePhotoUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return _buildUrl('assets/photo_profile/$filename');
  }

  static String? getAttendancePhotoUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return _buildUrl('assets/img_attendances/$filename');
  }

  static String? getTaskFileUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return _buildUrl('assets/file_tasks/$filename');
  }

  static String? getTaskFilePreviewUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return _buildUrl('assets/file_tasks/$filename/preview');
  }

  static String? getMessageImageUrl(String? image) {
    if (image == null || image.isEmpty) return null;
    if (image.startsWith('http')) return image;
    return _buildUrl('assets/message_images/$image');
  }
}
