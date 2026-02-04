import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member_model.dart';
import '../../../routes/app_pages.dart';

class MembersController extends GetxController {
  final searchController = TextEditingController();
  final members = <MemberModel>[].obs;
  final isLoading = false.obs;
  final selectedDepartment = 'All'.obs;
  final searchQuery = ''.obs;

  final List<String> departments = [
    'All',
    'UI/UX Designer',
    'Backend Developer',
    'Frontend Developer',
    'Mobile Developer',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  void fetchMembers() {
    isLoading.value = true;
    
    // Dummy data
    members.value = [
      MemberModel(
        id: '1',
        name: 'Sarah Johnson',
        email: 'sarah.j@company.com',
        department: 'UI/UX Designer',
        userType: 'Member',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
      ),
      MemberModel(
        id: '2',
        name: 'Michael Chen',
        email: 'michael.c@company.com',
        department: 'Backend Developer',
        userType: 'Supervisor',
        createdAt: DateTime.now().subtract(Duration(days: 60)),
      ),
      MemberModel(
        id: '3',
        name: 'Emily Davis',
        email: 'emily.d@company.com',
        department: 'Frontend Developer',
        userType: 'Member',
        createdAt: DateTime.now().subtract(Duration(days: 45)),
      ),
      MemberModel(
        id: '4',
        name: 'John Smith',
        email: 'john.s@company.com',
        department: 'Mobile Developer',
        userType: 'Member',
        createdAt: DateTime.now().subtract(Duration(days: 15)),
      ),
      MemberModel(
        id: '5',
        name: 'Lisa Anderson',
        email: 'lisa.a@company.com',
        department: 'UI/UX Designer',
        userType: 'Member',
        createdAt: DateTime.now().subtract(Duration(days: 20)),
      ),
    ];
    
    isLoading.value = false;
  }

  // Getter untuk filtered members - TIDAK dipanggil di dalam Obx
  List<MemberModel> getFilteredMembers() {
    var filtered = members.toList();

    // Filter by department
    if (selectedDepartment.value != 'All') {
      filtered = filtered
          .where((m) => m.department == selectedDepartment.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((m) {
        return m.name.toLowerCase().contains(query) ||
            m.email.toLowerCase().contains(query) ||
            m.department.toLowerCase().contains(query);
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
    Get.toNamed(Routes.MEMBER_DETAIL, arguments: member);
  }

  void goToCreateProfile() {
    Get.toNamed(Routes.CREATE_PROFILE);
  }

  void goToEditProfile(MemberModel member) {
    Get.toNamed(Routes.EDIT_PROFILE, arguments: member);
  }

  void deleteMember(String memberId) {
    members.removeWhere((m) => m.id == memberId);
    Get.snackbar('Success', 'Member deleted successfully');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
