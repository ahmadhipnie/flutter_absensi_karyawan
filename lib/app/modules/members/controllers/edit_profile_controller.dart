import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_pages.dart';

class EditProfileController extends GetxController {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  // Form controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final selectedImage = Rxn<File>();
  late String selectedRole;
  late UserModel user;

  final List<String> roles = ['member', 'supervisor'];

  @override
  void onInit() {
    super.onInit();
    
    // Get user from arguments
    user = Get.arguments as UserModel;
    
    // Initialize controllers
    nameController = TextEditingController(text: user.username);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone ?? '');
    selectedRole = user.role;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      // Request storage permission for Android 12 and below
      // For Android 13+ (API 33+), use photos permission
      PermissionStatus status;
      
      if (await Permission.photos.isGranted) {
        status = PermissionStatus.granted;
      } else if (await Permission.storage.isGranted) {
        status = PermissionStatus.granted;
      } else {
        // Try photos first (Android 13+)
        status = await Permission.photos.request();
        
        // If denied, try storage (Android 12-)
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }
      
      if (!status.isGranted) {
        Get.snackbar(
          'Permission Denied',
          'Please grant photo access permission in Settings',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error picking image: $e');
    }
  }

  /// Take photo from camera
  Future<void> takePhoto() async {
    try {
      // Request permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        Get.snackbar(
          'Permission Denied',
          'Please grant camera access permission',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error taking photo: $e');
    }
  }

  /// Show image picker options
  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                takePhoto();
              },
            ),
            if (selectedImage.value != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  selectedImage.value = null;
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Update user profile
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Call API to update user profile
      final updatedUser = await _userService.updateUser(
        userId: user.id,
        email: emailController.text.trim(),
        username: nameController.text.trim(),
        role: selectedRole,
        departmentId: user.departmentId,
        phone: phoneController.text.trim(),
        photoFile: selectedImage.value,
      );

      // Set loading false before navigation
      isLoading.value = false;

      // Close edit profile and also go back to members list so updated data is visible
      // First pop EditProfile -> returns to MemberDetail
      Get.back(result: true);
      
      // Small delay to allow navigation stack to settle
      await Future.delayed(const Duration(milliseconds: 250));
      
      // If we're not already at the members list, pop once more to go back
      if (Get.currentRoute != Routes.MEMBERS_LIST) {
        Get.back(result: true);
      }

      // Then show success message after navigation
      await Future.delayed(const Duration(milliseconds: 300));

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Profile "${updatedUser.displayName}" updated successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      // Set loading false
      isLoading.value = false;

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to update profile: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      print('Error updating profile: $e');
    }
  }

  /// Set role
  void setRole(String role) {
    selectedRole = role;
    update();
  }
}
