import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // Blue Background Header
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          
          // Main Card Layer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name & Role
                  Obx(() => Text(
                    controller.userName.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
                  SizedBox(height: 4),
                  Obx(() => Text(
                    controller.userRole.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
                  
                  SizedBox(height: 32),
                  
                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.analytics_outlined,
                    text: 'Attendance Log',
                    onTap: () => Get.toNamed(Routes.ATTENDANCE_LOG),
                  ),
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    text: 'Edit Profile',
                    onTap: () {
                      Get.toNamed(Routes.EDIT_MY_PROFILE);
                    },
                  ),
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildMenuItem(
                    icon: Icons.vpn_key_outlined,
                    text: 'Change Password',
                    onTap: () => Get.toNamed(Routes.CHANGE_MY_PASSWORD),
                  ),
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: controller.logout,
                  ),
                ],
              ),
            ),
          ),
          
          // Avatar (floating on top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Border effect
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=5'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Icon(
        icon, 
        color: iconColor ?? Colors.grey[800],
        size: 20,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 20,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
