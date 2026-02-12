import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Android notification channel for high importance notifications
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // must match AndroidManifest.xml
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase and FCM
  Future<FcmService> init() async {
    try {
      // 1. Setup local notifications (for Android foreground)
      await _setupLocalNotifications();

      // 2. Request notification permission
      await _requestPermission();

      // 3. Get FCM token
      _fcmToken = await _messaging.getToken();
      if (kDebugMode) {
        print('🔔 FCM Token: $_fcmToken');
      }

      // 4. Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      // 5. Configure foreground notification presentation (iOS only)
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 6. Setup message handlers
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

  /// Setup flutter_local_notifications for Android foreground notifications
  Future<void> _setupLocalNotifications() async {
    // Android init settings
    const androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init settings
    const darwinInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_androidChannel);

      // Request notification permission for Android 13+
      await androidPlugin.requestNotificationsPermission();

      if (kDebugMode) {
        print('✅ Android notification channel created');
      }
    }
  }

  /// Handle notification tap from local notification
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('🔔 Local notification tapped: ${response.payload}');
    }

    // Parse payload and navigate
    if (response.payload != null && response.payload!.isNotEmpty) {
      // Payload format: "type:id" e.g. "task:123"
      final parts = response.payload!.split(':');
      if (parts.length >= 2) {
        _navigateFromNotification({'type': parts[0], 'id': parts[1]});
      } else if (parts.isNotEmpty) {
        _navigateFromNotification({'type': parts[0]});
      }
    }
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
    // Foreground messages — show local notification on Android
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // When user taps notification while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from terminated state via notification
    _checkInitialMessage();
  }

  /// Handle foreground messages — MUST show notification manually on Android
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('🔔 Foreground message received:');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
    }

    // Show local notification on Android when app is in foreground
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null) {
      // Build payload string for navigation on tap
      String? payload;
      if (message.data.isNotEmpty) {
        final type = message.data['type'] ?? '';
        final id = message.data['id'] ?? '';
        payload = '$type:$id';
      }

      _localNotifications.show(
        id: notification.hashCode, // unique notification id
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );

      if (kDebugMode) {
        print('✅ Local notification shown for foreground message');
      }
    }
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
          Get.toNamed(Routes.TASK_DETAIL,
              arguments: {'taskId': int.tryParse(id)});
        }
        break;
      case 'attendance':
        Get.toNamed(Routes.ATTENDANCE);
        break;
      case 'announcement':
        if (id != null) {
          Get.toNamed(Routes.ANNOUNCEMENT_DETAIL,
              arguments: {'announcementId': int.tryParse(id)});
        } else {
          Get.toNamed(Routes.NOTIFICATIONS);
        }
        break;
      case 'chat':
        if (id != null) {
          Get.toNamed(Routes.CHAT_DETAIL,
              arguments: {'conversationId': int.tryParse(id)});
        }
        break;
      default:
        // Default: go to notifications page
        if (type != null && type.isNotEmpty) {
          Get.toNamed(Routes.NOTIFICATIONS);
        }
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
