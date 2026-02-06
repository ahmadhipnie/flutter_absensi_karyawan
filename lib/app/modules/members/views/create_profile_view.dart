import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_profile_controller.dart';
import '../../../common/widgets/app_back_button.dart';
import './widgets/profile_form_field.dart';
import './widgets/profile_dropdown_field.dart';
import './widgets/profile_save_button.dart';

class CreateProfileView extends GetView<CreateProfileController> {
  const CreateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: const AppBackButton(),
        title: const Text(
          'Create Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Obx(() => ProfileSaveButton(
                onPressed: controller.isLoading.value ? null : controller.createUser,
                isLoading: controller.isLoading.value,
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with image picker
              Obx(() {
                final selectedImage = controller.selectedImage.value;
                return Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: selectedImage != null 
                              ? FileImage(selectedImage) as ImageProvider
                              : null,
                          child: selectedImage == null
                              ? const Icon(Icons.person, size: 40, color: Colors.grey)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.showImagePickerOptions,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF003AE6),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 32),
              _buildFormFields(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileFormField(
              label: 'Employee Name',
              controller: controller.nameController,
              hint: 'Enter full name',
              validator: controller.validateName,
            ),
            const SizedBox(height: 16),
            ProfileFormField(
              label: 'Email',
              controller: controller.emailController,
              hint: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),
            const SizedBox(height: 16),
            // Department Dropdown
            ProfileDropdownField(
              label: 'Department',
              value: controller.selectedDepartment.value?.name ?? 
                     (controller.departments.isEmpty ? 'No departments' : controller.departments.first.name),
              items: controller.departments.isEmpty
                  ? ['No departments']
                  : controller.departments.map((d) => d.name).toList(),
              onChanged: (val) {
                if (val != null && controller.departments.isNotEmpty) {
                  final dept = controller.departments.firstWhere((d) => d.name == val);
                  controller.setDepartment(dept);
                }
              },
            ),
            const SizedBox(height: 16),
            // Role Dropdown
            ProfileDropdownField(
              label: 'User Type',
              value: controller.selectedRole.value,
              items: const ['member', 'supervisor'],
              onChanged: (val) {
                if (val != null) {
                  controller.setRole(val);
                }
              },
            ),
            const SizedBox(height: 16),
            ProfileFormField(
              label: 'Create Password',
              controller: controller.passwordController,
              isPassword: true,
              hint: '•••••••',
              validator: controller.validatePassword,
            ),
            const SizedBox(height: 16),
            ProfileFormField(
              label: 'Confirm Password',
              controller: controller.confirmPasswordController,
              isPassword: true,
              hint: '•••••••',
              validator: controller.validateConfirmPassword,
            ),
          ],
        ));
  }
}
