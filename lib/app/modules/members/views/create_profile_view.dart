import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/app_back_button.dart';
import './widgets/profile_avatar_section.dart';
import './widgets/profile_form_field.dart';
import './widgets/profile_dropdown_field.dart';
import './widgets/profile_save_button.dart';

class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  static const List<String> departments = [
    'UI/UX Designer',
    'Backend Developer',
    'Frontend Developer',
    'Mobile Developer',
  ];

  static const List<String> userTypes = ['Member', 'Supervisor'];

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

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
          ProfileSaveButton(onPressed: _handleCreate),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatarSection(avatarUrl: null),
              SizedBox(height: 32),
              _FormFields(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.snackbar(
        'Success',
        'Profile created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    }
  }
}

class _FormFields extends StatefulWidget {
  const _FormFields();

  @override
  State<_FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<_FormFields> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedDepartment = CreateProfileView.departments.first;
  String _selectedUserType = CreateProfileView.userTypes.first;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormField(
          label: 'Employee Name',
          controller: _nameController,
          hint: 'Alsaa Cantikk',
          validator: (value) => value?.isEmpty == true ? 'Please enter name' : null,
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          label: 'Email',
          controller: _emailController,
          hint: 'alsaacantikk464@gmail.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) => !GetUtils.isEmail(value ?? '') ? 'Invalid email' : null,
        ),
        const SizedBox(height: 16),
        ProfileDropdownField(
          label: 'Department',
          value: _selectedDepartment,
          items: CreateProfileView.departments,
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedDepartment = val);
            }
          },
        ),
        const SizedBox(height: 16),
        ProfileDropdownField(
          label: 'User Type',
          value: _selectedUserType,
          items: CreateProfileView.userTypes,
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedUserType = val);
            }
          },
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          label: 'Create Password',
          controller: _passwordController,
          isPassword: true,
          hint: '•••••••',
          validator: (value) => (value?.length ?? 0) < 6 ? 'Min 6 chars' : null,
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          label: 'Confirm Password',
          controller: _confirmPasswordController,
          isPassword: true,
          hint: '•••••••',
          validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
        ),
      ],
    );
  }
}
