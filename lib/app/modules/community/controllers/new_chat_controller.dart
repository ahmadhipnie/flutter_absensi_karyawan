import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../members/models/member_model.dart';
import '../../../routes/app_pages.dart';

class NewChatController extends GetxController {
  final searchController = TextEditingController();
  final members = <MemberModel>[].obs;
  final filteredMembers = <MemberModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  void fetchMembers() {
    isLoading.value = true;
    
    // Using dummy data similar to MembersController
    // In a real app, this would come from a service/API
    final dummyData = [
      MemberModel(
        id: '1',
        name: 'Sarah Johnson',
        email: 'sarah.j@company.com',
        department: 'UI/UX Designer',
        userType: 'Member',
      ),
      MemberModel(
        id: '2',
        name: 'Michael Chen',
        email: 'michael.c@company.com',
        department: 'Backend Developer',
        userType: 'Supervisor',
      ),
      MemberModel(
        id: '3',
        name: 'Emily Davis',
        email: 'emily.d@company.com',
        department: 'Frontend Developer',
        userType: 'Member',
      ),
      MemberModel(
        id: '4',
        name: 'John Smith',
        email: 'john.s@company.com',
        department: 'Mobile Developer',
        userType: 'Member',
      ),
      MemberModel(
        id: '5',
        name: 'Lisa Anderson',
        email: 'lisa.a@company.com',
        department: 'UI/UX Designer',
        userType: 'Member',
      ),
      MemberModel(
        id: '6',
        name: 'David Wilson',
        email: 'david.w@company.com',
        department: 'Project Manager',
        userType: 'Supervisor',
      ),
      MemberModel(
        id: '7',
        name: 'Jessica Brown',
        email: 'jessica.b@company.com',
        department: 'QA Engineer',
        userType: 'Member',
      ),
    ];
    
    members.assignAll(dummyData);
    filteredMembers.assignAll(dummyData);
    isLoading.value = false;
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (value.isEmpty) {
      filteredMembers.assignAll(members);
    } else {
      final query = value.toLowerCase();
      filteredMembers.assignAll(members.where((m) {
        return m.name.toLowerCase().contains(query) ||
               m.department.toLowerCase().contains(query);
      }).toList());
    }
  }

  void startPersonalChat(MemberModel member) {
    // Navigate to Chat Detail with member info
    Get.toNamed(
      Routes.CHAT_DETAIL,
      arguments: {
        'chatId': 'new_${member.id}',
        'name': member.name,
        'type': 'Personal',
        'avatarUrl': member.avatarUrl,
      },
    );
  }

  void createNewGroup() {
    Get.snackbar('Coming Soon', 'Group chat creation is not implemented yet.');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
