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
}
