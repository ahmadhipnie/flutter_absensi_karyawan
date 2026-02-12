import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../providers/api_provider.dart';

class DeviceTokenService extends GetxService {
  ApiProvider get _apiProvider => ApiProvider.instance;

  /// Register device token to backend
  /// POST /api/device-tokens
  Future<bool> registerDeviceToken({
    required String deviceToken,
    required String deviceType,
    String? appVersion,
  }) async {
    try {
      final data = {
        'device_token': deviceToken,
        'device_type': deviceType,
        if (appVersion != null) 'app_version': appVersion,
      };

      final response = await _apiProvider.post(
        '/device-tokens',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Device token registered successfully');
        }
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Failed to register device token: ${e.message}');
        print('Response: ${e.response?.data}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected error registering device token: $e');
      }
      return false;
    }
  }

  /// Remove device token from backend (on logout)
  /// DELETE /api/device-tokens
  Future<bool> removeDeviceToken({
    required String deviceToken,
  }) async {
    try {
      final response = await _apiProvider.delete(
        '/device-tokens',
        data: {'device_token': deviceToken},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (kDebugMode) {
          print('✅ Device token removed successfully');
        }
        return true;
      }

      return false;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Failed to remove device token: ${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected error removing device token: $e');
      }
      return false;
    }
  }
}
