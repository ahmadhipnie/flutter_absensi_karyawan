import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import '../models/member_model.dart';
import '../../../routes/app_pages.dart';

class MembersController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/department_service.dart';
import '../../../routes/app_pages.dart';

class MembersController extends GetxController {
  final UserService _userService = UserService();
  final DepartmentService _departmentService = DepartmentService();
  
  final searchController = TextEditingController();
  final users = <UserModel>[].obs;
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

  // Getter untuk filtered members
  List<MemberModel> getFilteredMembers() {
    var filtered = members.toList();
    loadDepartments();
    fetchUsers();
  }
  
  /// Load departments for filter
  Future<void> loadDepartments() async {
    try {
      final departmentsList = await _departmentService.getDepartments();
      departments.value = ['All', ...departmentsList.map((d) => d.name).toList()];
    } catch (e) {
      print('Error loading departments: $e');
      // Keep default departments if error
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final usersList = await _userService.getUsers();
      users.value = usersList;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load users: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Getter untuk filtered users - TIDAK dipanggil di dalam Obx
  List<UserModel> getFilteredUsers() {
    var filtered = users.toList();

    // Filter by department
    if (selectedDepartment.value != 'All') {
      // TODO: Need to map department_id to department name
      // For now, we'll skip department filtering until we have department names
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((m) {
        return m.displayName.toLowerCase().contains(query) ||
            m.email.toLowerCase().contains(query) ||
            m.department.toLowerCase().contains(query);
      filtered = filtered.where((u) {
        return u.displayName.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query) ||
            u.role.toLowerCase().contains(query);
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

  void goToMemberDetail(MemberModel member) {
    pausePolling(); // Stop polling saat buka detail
    Get.toNamed(Routes.MEMBER_DETAIL, arguments: member);
  void goToMemberDetail(UserModel user) {
    Get.toNamed(Routes.MEMBER_DETAIL, arguments: user);
  }

  void goToCreateProfile() async {
    final result = await Get.toNamed(Routes.CREATE_PROFILE);
    
    // Refresh list if user was created
    if (result == true) {
      fetchUsers();
    }
  }

  void goToEditProfile(MemberModel member) {
    pausePolling(); // Stop polling saat buka edit
    Get.toNamed(Routes.EDIT_PROFILE, arguments: member);
  }

  /// Resume polling when back from detail page
  void onResume() {
    resumePolling();
  void goToEditProfile(UserModel user) {
    Get.toNamed(Routes.EDIT_PROFILE, arguments: user);
  }

  void deleteUser(int userId) {
    users.removeWhere((u) => u.id == userId);
    Get.snackbar('Success', 'User deleted successfully');
  }

  void deleteMember(String memberId) {
    members.removeWhere((m) => m.id.toString() == memberId);
    Get.snackbar('Success', 'Member deleted successfully');
  }
}
