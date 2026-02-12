import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/services/device_token_service.dart';
import '../../routes/app_pages.dart';

/// Top-level function to handle background messages
/// Must be a top-level function (not a class method)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('🔔 Background message received: ${message.messageId}');
    print('   Title: ${message.notification?.title}');
    print('   Body: ${message.notification?.body}');
    print('   Data: ${message.data}');
  }
}

class FcmService extends GetxService {
  static FcmService get instance => Get.find<FcmService>();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase and FCM
  Future<FcmService> init() async {
    try {
      // Request notification permission
      await _requestPermission();

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) {
        print('🔔 FCM Token: $_fcmToken');
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      // Configure foreground notification presentation
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Setup message handlers
      _setupMessageHandlers();

      if (kDebugMode) {
        print('✅ FCM Service initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ FCM initialization error: $e');
      }
    }

    return this;
  }

  /// Request notification permission from user
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('🔔 Notification permission: ${settings.authorizationStatus}');
    }
  }

  /// Handle FCM token refresh
  void _onTokenRefresh(String newToken) {
    if (kDebugMode) {
      print('🔔 FCM Token refreshed: $newToken');
    }
    _fcmToken = newToken;

    // Re-register with backend if DeviceTokenService is available
    _registerTokenWithBackend(newToken);
  }

  /// Setup message handlers for foreground, background tap, and terminated tap
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // When user taps notification while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from terminated state via notification
    _checkInitialMessage();
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('🔔 Foreground message received:');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
    }

    // The notification will be shown automatically by the system
    // because we set setForegroundNotificationPresentationOptions above.
    // No need to manually create local notification.
  }

  /// Handle notification tap (from background)
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('🔔 Notification tapped (background):');
      print('   Data: ${message.data}');
    }

    _navigateFromNotification(message.data);
  }

  /// Check if the app was opened from a terminated state via notification
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      if (kDebugMode) {
        print('🔔 App opened from terminated notification:');
        print('   Data: ${initialMessage.data}');
      }

      // Delay navigation to let the app fully initialize
      await Future.delayed(const Duration(seconds: 2));
      _navigateFromNotification(initialMessage.data);
    }
  }

  /// Navigate to specific screen based on notification data payload
  void _navigateFromNotification(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    if (kDebugMode) {
      print('🔔 Navigating from notification - type: $type, id: $id');
    }

    switch (type) {
      case 'task':
        if (id != null) {
          Get.toNamed(Routes.TASK_DETAIL, arguments: {'taskId': int.tryParse(id)});
        }
        break;
      case 'attendance':
        Get.toNamed(Routes.ATTENDANCE);
        break;
      case 'announcement':
        if (id != null) {
          Get.toNamed(Routes.ANNOUNCEMENT_DETAIL, arguments: {'announcementId': int.tryParse(id)});
        } else {
          Get.toNamed(Routes.NOTIFICATIONS);
        }
        break;
      case 'chat':
        if (id != null) {
          Get.toNamed(Routes.CHAT_DETAIL, arguments: {'conversationId': int.tryParse(id)});
        }
        break;
      default:
        // Default: go to notifications page
        Get.toNamed(Routes.NOTIFICATIONS);
        break;
    }
  }

  /// Register current FCM token with the backend
  Future<void> registerTokenWithBackend() async {
    if (_fcmToken == null) return;
    await _registerTokenWithBackend(_fcmToken!);
  }

  /// Internal method to register token with backend
  Future<void> _registerTokenWithBackend(String token) async {
    try {
      if (!Get.isRegistered<DeviceTokenService>()) return;

      final deviceTokenService = Get.find<DeviceTokenService>();
      final deviceType = Platform.isAndroid ? 'android' : 'ios';

      await deviceTokenService.registerDeviceToken(
        deviceToken: token,
        deviceType: deviceType,
        appVersion: '1.0.0',
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to register token with backend: $e');
      }
    }
  }

  /// Remove token from backend (call on logout)
  Future<void> removeTokenFromBackend() async {
    if (_fcmToken == null) return;

    try {
      if (!Get.isRegistered<DeviceTokenService>()) return;

      final deviceTokenService = Get.find<DeviceTokenService>();
      await deviceTokenService.removeDeviceToken(deviceToken: _fcmToken!);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to remove token from backend: $e');
      }
    }
  }
}
