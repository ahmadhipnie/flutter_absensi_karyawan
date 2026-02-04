import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member_model.dart';
import '../../../core/theme/app_theme.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late String _selectedDepartment;
  late String _selectedUserType;
  
  final List<String> _departments = [
    'UI/UX Designer',
    'Backend Developer',
    'Frontend Developer',
    'Mobile Developer',
  ];
  
  final List<String> _userTypes = ['Member', 'Supervisor'];

  @override
  void initState() {
    super.initState();
    final MemberModel member = Get.arguments as MemberModel;
    _nameController = TextEditingController(text: member.name);
    _emailController = TextEditingController(text: member.email);
    _selectedDepartment = member.department;
    _selectedUserType = member.userType;
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: _handleUpdate,
                  icon: Icon(Icons.edit_square, size: 16, color: AppTheme.primaryColor),
                  label: Text(
                    'Update', 
                    style: TextStyle(
                      color: AppTheme.primaryColor, 
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade100,
                        // Placeholder image logic
                        backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=5'),
                        onBackgroundImageError: (_, __) {},
                        child: null, 
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Name Field
              _buildLabel('Employee Name'),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter name',
                validator: (value) => value?.isEmpty == true ? 'Please enter name' : null,
              ),
              
              SizedBox(height: 16),
              
              // Email Field
              _buildLabel('Email'),
              _buildTextField(
                controller: _emailController,
                hint: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => !GetUtils.isEmail(value ?? '') ? 'Invalid email' : null,
              ),
              
              SizedBox(height: 16),
              
              // Department Dropdown
              _buildLabel('Department'),
              _buildDropdown(
                value: _selectedDepartment,
                items: _departments,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedDepartment = val);
                  }
                },
              ),

              const SizedBox(height: 16),

              // User Type Dropdown
              _buildLabel('User Type'),
              _buildDropdown(
                value: _selectedUserType,
                items: _userTypes,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedUserType = val);
                  }
                },
              ),
              
              SizedBox(height: 16),
              
              // Create Password
              _buildLabel('Create Password'),
              _buildTextField(
                controller: _passwordController,
                isPassword: true,
                hint: '•••••••',
              ),
              
              SizedBox(height: 16),
              
              // Confirm Password
              _buildLabel('Confirm Password'),
              _buildTextField(
                controller: _confirmPasswordController,
                isPassword: true,
                hint: '•••••••',
                validator: (value) {
                  if (_passwordController.text.isNotEmpty && value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement update profile logic
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    }
  }
}
