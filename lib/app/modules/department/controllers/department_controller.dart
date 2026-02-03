import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentController extends GetxController with GetSingleTickerProviderStateMixin {
  // Form Controllers
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  
  // Tabs for Detail View
  late TabController tabController;
  final tabs = ['Task', 'Discussion', 'Members'];

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    tabController.dispose();
    super.onClose();
  }

  void saveDepartment() {
    // Logic to save
    Get.back();
    Get.snackbar('Success', 'Department created successfully');
  }

  void updateDepartment() {
    // Logic to update
    Get.back();
    Get.snackbar('Success', 'Department updated successfully');
  }
}
