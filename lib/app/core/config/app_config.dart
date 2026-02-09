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
    return url;
  }

  static String? getDepartmentPhotoUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return 'https://api-absensi.hftech.web.id/api/assets/departments_photo/$filename';
  }

  static String? getProfilePhotoUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return 'https://api-absensi.hftech.web.id/api/assets/photo_profile/$filename';
  }

  static String? getAttendancePhotoUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    // Support both with and without /api prefix
    return 'https://api-absensi.hftech.web.id/assets/img_attendances/$filename';
  }

  static String? getTaskFileUrl(String? filename) {
    if (filename == null || filename.isEmpty) return null;
    if (filename.startsWith('http')) return filename;
    return 'https://api-absensi.hftech.web.id/assets/file_tasks/$filename';
  }
}
