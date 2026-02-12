import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

/// Service to track read notification IDs locally.
/// Used since the API doesn't provide read/unread status.
class NotificationReadStorage extends GetxService {
  static const String _key = 'read_notification_ids';
  SharedPreferences? _prefs;

  final _readIds = <int>{}.obs;
  final _updateTrigger = 0.obs;

  /// Reactive trigger that increments when read state changes
  RxInt get updateTrigger => _updateTrigger;

  Set<int> get readIds => Set.unmodifiable(_readIds);

  @override
  void onInit() {
    super.onInit();
    _loadReadIds();
  }

  Future<void> _loadReadIds() async {
    _prefs ??= await SharedPreferences.getInstance();
    final stored = _prefs!.getStringList(_key);
    if (stored != null) {
      _readIds.clear();
      _readIds.addAll(stored.map(int.parse));
    }
  }

  /// Mark a notification as read by storing its ID
  Future<void> markAsRead(int notificationId) async {
    if (!_readIds.contains(notificationId)) {
      _readIds.add(notificationId);
      _updateTrigger.value++;
      await _persist();
    }
  }

  /// Mark multiple notifications as read
  Future<void> markMultipleAsRead(Set<int> ids) async {
    var added = false;
    for (final id in ids) {
      if (!_readIds.contains(id)) {
        _readIds.add(id);
        added = true;
      }
    }
    if (added) {
      await _persist();
    }
  }

  /// Check if a notification has been read
  bool isRead(int notificationId) {
    return _readIds.contains(notificationId);
  }

  /// Get count of unread notifications from the provided list
  int getUnreadCount(List<int> allNotificationIds) {
    return allNotificationIds.where((id) => !_readIds.contains(id)).length;
  }

  /// Clear all read notification IDs (for logout/testing)
  Future<void> clear() async {
    _readIds.clear();
    await _persist();
  }

  Future<void> _persist() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setStringList(_key, _readIds.map((id) => id.toString()).toList());
  }
}
