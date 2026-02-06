import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../data/services/department_service.dart';
import '../../../data/models/department_model.dart';
import '../../../data/models/department_task_model.dart';
import '../../members/controllers/members_controller.dart';

class DepartmentController extends GetxController with GetSingleTickerProviderStateMixin {
  final DepartmentService _departmentService = DepartmentService();
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  
  // Tabs for Detail View
  late TabController tabController;
  final tabs = ['Task', 'Discussion', 'Members'];

  // Observable states
  final isLoading = false.obs;
  final isLoadingTasks = false.obs;
  final selectedImage = Rxn<File>();
  
  // Current department data (for detail/edit/info views)
  final department = Rxn<DepartmentModel>();
  final departmentTasks = <DepartmentTaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    tabController = TabController(length: tabs.length, vsync: this);
    
    // Load department from arguments if available
    if (Get.arguments is DepartmentModel) {
      department.value = Get.arguments as DepartmentModel;
    }
    
    // Fetch members data to ensure it's fresh
    _fetchMembersData();

    // Fetch department tasks if department is loaded
    if (department.value != null) {
      fetchDepartmentTasks();
    }
  }
  
  /// Fetch members data to ensure member count is accurate
  Future<void> _fetchMembersData() async {
    try {
      // If MembersController is registered, refresh its data
      if (Get.isRegistered<MembersController>()) {
        final membersController = Get.find<MembersController>();
        await membersController.fetchMembers(silent: true);
      }
    } catch (e) {
      print('Error fetching members: $e');
    }
  }

  /// Fetch department tasks
  Future<void> fetchDepartmentTasks() async {
    if (department.value == null) return;
    
    try {
      isLoadingTasks.value = true;
      final tasks = await _departmentService.getDepartmentTasks(department.value!.id);
      departmentTasks.assignAll(tasks);
    } catch (e) {
      print('Error fetching department tasks: $e');
      // Optionally show snackbar for task fetch error, or just log it
    } finally {
      isLoadingTasks.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    tabController.dispose();
    super.onClose();
  }
  
  /// Load form with existing department data for editing
  void loadDepartmentForEdit() {
    if (department.value != null) {
      nameController.text = department.value!.name;
      descriptionController.text = department.value!.description;
    }
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

  Future<void> saveDepartment() async {
    // Validate inputs
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter department name',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter description',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final newDepartment = await _departmentService.createDepartment(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        photoFile: selectedImage.value,
      );

      // Set loading false BEFORE navigation
      isLoading.value = false;

      // Go back first
      Get.back(result: true);

      // Then show success message after navigation
      await Future.delayed(const Duration(milliseconds: 300));

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Department "${newDepartment.name}" created successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      // Set loading false on error
      isLoading.value = false;

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to create department: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      print('Error creating department: $e');
    }
  }

  void updateDepartment() async {
    // Validate inputs
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter department name',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter description',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (department.value == null) return;

    try {
      isLoading.value = true;

      final updatedDepartment = await _departmentService.updateDepartment(
        departmentId: department.value!.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        photoFile: selectedImage.value,
      );

      // Update local department data
      department.value = updatedDepartment;

      isLoading.value = false;

      // Go back from edit to info/detail
      Get.back(result: true);

      await Future.delayed(const Duration(milliseconds: 300));

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Department updated successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      isLoading.value = false;

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to update department: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      print('Error updating department: $e');
    }
  }

  /// Delete department
  Future<void> deleteDepartment() async {
    if (department.value == null) return;

    // Show confirm dialog
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red[700], size: 28),
            const SizedBox(width: 12),
            const Text(
              'Delete Department',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${department.value!.name}"?',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close confirm dialog
              await Future.delayed(const Duration(milliseconds: 100));
              _performDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _performDelete() async {
    // Show loading
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting department...', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await _departmentService.deleteDepartment(department.value!.id);

      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      await Future.delayed(const Duration(milliseconds: 200));

      // Navigate back to dashboard (close detail + info if open)
      // We use Get.until to go back until dashboard
      Get.back(result: true); // Close current view (info or edit)
      
      // Also try to close department detail if we're nested
      await Future.delayed(const Duration(milliseconds: 100));
      if (Get.currentRoute.contains('department')) {
        Get.back(result: true);
      }

      await Future.delayed(const Duration(milliseconds: 300));

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Department deleted successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to delete department: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      print('Error deleting department: $e');
    }
  }
}