import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/department_service.dart';
import '../../../data/models/user_model.dart';

class CreateAnnouncementController extends GetxController {
  final DepartmentService _departmentService = DepartmentService();

  final subjectController = ''.obs;
  final messageController = ''.obs;
  final isLoading = false.obs;
  
  // Members data for selection
  // Structure: {'id': int, 'name': String, 'avatar': String, 'isSelected': bool, 'user': UserModel}
  final allMembers = <Map<String, dynamic>>[].obs;
  final selectedMembers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is List) {
      final list = Get.arguments as List;
      if (list.isNotEmpty) {
        // Handle both direct UserModel list or dynamic list
        final users = list.map((e) => e as UserModel).toList();
        
        allMembers.value = users.map((u) => {
          'id': u.id,
          'name': u.displayName,
          'avatar': u.avatarUrl,
          'isSelected': true, // Default to all selected
          'user': u,
        }).toList();
      }
    }
    updateSelectedMembers();
  }

  void toggleMemberSelection(int index) {
    var member = allMembers[index];
    member['isSelected'] = !(member['isSelected'] as bool);
    allMembers[index] = member;
    updateSelectedMembers();
  }

  void updateSelectedMembers() {
    selectedMembers.value = allMembers.where((m) => m['isSelected'] == true).toList();
  }

  String get notifyToText {
    if (allMembers.isEmpty) return 'No Members';
    if (selectedMembers.isEmpty) return 'Select Members';
    if (selectedMembers.length == allMembers.length) return 'All Member';
    return '${selectedMembers.length} Members Selected';
  }

  Future<void> postAnnouncement() async {
    if (isLoading.value) return;

    if (subjectController.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a subject',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (messageController.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a message',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (selectedMembers.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one member',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final recipientIds = selectedMembers.map((m) => m['id'] as int).toList();
      final isBroadcast = recipientIds.length == allMembers.length;

      await _departmentService.createAnnouncement(
        subject: subjectController.value,
        message: messageController.value,
        isBroadcast: isBroadcast,
        recipientIds: recipientIds,
      );

      isLoading.value = false;
      
      Get.back(); // Go back to department detail
      
      Get.snackbar(
        'Success',
        'Announcement posted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}