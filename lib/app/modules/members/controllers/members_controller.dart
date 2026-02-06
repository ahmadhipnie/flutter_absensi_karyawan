import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
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

  void goToMemberDetail(UserModel user) async {
    final result = await Get.toNamed(Routes.MEMBER_DETAIL, arguments: user);
    
    // Refresh list if user was deleted
    if (result == true) {
      fetchUsers();
    }
  }

  void goToCreateProfile() async {
    final result = await Get.toNamed(Routes.CREATE_PROFILE);
    
    // Refresh list if user was created
    if (result == true) {
      fetchUsers();
    }
  }

  void goToEditProfile(UserModel user) {
    Get.toNamed(Routes.EDIT_PROFILE, arguments: user);
  }

  void deleteUser(int userId) {
    users.removeWhere((u) => u.id == userId);
    Get.snackbar('Success', 'User deleted successfully');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
