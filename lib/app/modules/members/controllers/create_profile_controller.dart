import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/department_service.dart';
import '../../../data/models/department_model.dart';

class CreateProfileController extends GetxController {
  final UserService _userService = UserService();
  final DepartmentService _departmentService = DepartmentService();

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final departments = <DepartmentModel>[].obs;
  final selectedDepartment = Rxn<DepartmentModel>();
  final selectedRole = 'member'.obs; // 'member' or 'supervisor'

  final List<String> roles = ['member', 'supervisor'];

  @override
  void onInit() {
    super.onInit();
    loadDepartments();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Load departments from API
  Future<void> loadDepartments() async {
    try {
      final departmentsList = await _departmentService.getDepartments();
      departments.value = departmentsList;
      
      // Set first department as default if available
      if (departmentsList.isNotEmpty) {
        selectedDepartment.value = departmentsList.first;
      }
    } catch (e) {
      print('Error loading departments: $e');
      // Show error but don't block UI
    }
  }

  /// Validate form
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Create new user
  Future<void> createUser() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final newUser = await _userService.registerUser(
        email: emailController.text.trim(),
        username: nameController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value,
        departmentId: selectedDepartment.value?.id,
      );

      // Show success message
      Get.snackbar(
        'Success',
        'User "${newUser.displayName}" has been created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Go back and refresh members list
      Get.back(result: true);
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to create user: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      print('Error creating user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set selected department
  void setDepartment(DepartmentModel? department) {
    selectedDepartment.value = department;
  }

  /// Set selected role
  void setRole(String role) {
    selectedRole.value = role;
  }
}
