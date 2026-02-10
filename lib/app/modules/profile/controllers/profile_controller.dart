import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/department_service.dart';
import '../../../data/models/department_model.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserService _userService = Get.find<UserService>();
  final DepartmentService _departmentService = Get.find<DepartmentService>();
  final ImagePicker _picker = ImagePicker();

  final userRole = ''.obs;
  final userName = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;
  final phone = ''.obs;

  // For Member specific
  final department = ''.obs;
  final departmentId = Rxn<int>();
  final departmentList = <DepartmentModel>[].obs;

  // For profile photo
  final selectedPhoto = Rxn<File>();
  
  // Loading states
  final isLoading = false.obs;
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadDepartments();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      userName.value = user.username ?? user.email.split('@')[0];
      email.value = user.email;
      userRole.value = user.role;
      phone.value = user.phone ?? '';
      avatarUrl.value = user.avatarUrl;
      
      if (user.departmentId != null) {
        departmentId.value = user.departmentId;
      }
    }
  }

  Future<void> _loadDepartments() async {
    try {
      isLoading.value = true;
      final departments = await _departmentService.getDepartments();
      departmentList.value = departments;
      
      // Set initial department name if user has departmentId
      if (departmentId.value != null) {
        final dept = departments.firstWhereOrNull(
          (d) => d.id == departmentId.value,
        );
        if (dept != null) {
          department.value = dept.name;
        }
      }
    } catch (e) {
      print('Error loading departments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectDepartment(DepartmentModel dept) {
    department.value = dept.name;
    departmentId.value = dept.id;
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
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
        selectedPhoto.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Take photo from camera
  Future<void> takePhoto() async {
    try {
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
        selectedPhoto.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
            if (selectedPhoto.value != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  selectedPhoto.value = null;
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String emailAddress,
  }) async {
    try {
      isUpdating.value = true;

      final user = _authService.currentUser;
      if (user == null) {
        throw 'User not found';
      }

      // Call update user API
      final updatedUser = await _userService.updateUser(
        userId: user.id,
        email: emailAddress,
        username: name,
        role: user.role,
        departmentId: departmentId.value,
        phone: phone.value.isNotEmpty ? phone.value : null,
        photoFile: selectedPhoto.value,
      );

      // Update current user in AuthService
      await _authService.updateCurrentUser(updatedUser);

      // Reload user data
      _loadUserData();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back after a short delay to allow user to see the success message
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  void logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }
}