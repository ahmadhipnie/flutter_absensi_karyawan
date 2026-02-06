import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/chat_service.dart';
import '../../../routes/app_pages.dart';

class MembersController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  final searchController = TextEditingController();
  final members = <UserModel>[].obs;
  final isLoading = false.obs;
  final selectedDepartment = 'All'.obs;
  final searchQuery = ''.obs;

  final departments = <String>['All'].obs;

  // Polling timer
  Timer? _pollTimer;

  // Polling interval (30 seconds)
  static const Duration _pollInterval = Duration(seconds: 30);

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
    _startPolling();
  }

  @override
  void onClose() {
    _stopPolling();
    searchController.dispose();
    super.onClose();
  }

  /// Start smart polling
  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      fetchMembers(silent: true);
    });
  }

  /// Stop smart polling
  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Pause polling
  void pausePolling() {
    _stopPolling();
  }

  /// Resume polling
  void resumePolling() {
    _startPolling();
  }

  /// Fetch members from API
  Future<void> fetchMembers({bool silent = false}) async {
    try {
      if (!silent) isLoading.value = true;

      final result = await _chatService.getUsers();
      members.assignAll(result);
    } catch (e) {
      if (!silent) {
        Get.snackbar('Error', 'Failed to load members');
      }
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  /// Refresh members (manual refresh)
  Future<void> refresh() async {
    await fetchMembers();
  }

  /// Get filtered members
  List<UserModel> getFilteredMembers() {
    var filtered = members.toList();

    // Filter by department (using location field)
    if (selectedDepartment.value != 'All') {
      filtered = filtered.where((m) => m.location == selectedDepartment.value).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((m) {
        return m.displayName.toLowerCase().contains(query) ||
            m.email.toLowerCase().contains(query) ||
            m.role.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void filterByDepartment(String department) {
    selectedDepartment.value = department;
  }

  void goToMemberDetail(UserModel member) {
    pausePolling();
    Get.toNamed(Routes.MEMBER_DETAIL, arguments: member)?.then((_) {
      resumePolling();
    });
  }

  void goToCreateProfile() async {
    final result = await Get.toNamed(Routes.CREATE_PROFILE);

    // Refresh list if user was created
    if (result == true) {
      fetchMembers();
    }
  }

  void goToEditProfile(UserModel member) {
    pausePolling();
    Get.toNamed(Routes.EDIT_PROFILE, arguments: member)?.then((_) {
      resumePolling();
    });
  }

  void deleteMember(String memberId) {
    members.removeWhere((m) => m.id.toString() == memberId);
    Get.snackbar('Success', 'Member deleted successfully');
  }

  void deleteUser(int userId) {
    members.removeWhere((m) => m.id == userId);
    Get.snackbar('Success', 'Member deleted successfully');
  }
}
